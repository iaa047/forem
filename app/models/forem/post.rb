module Forem
  class Post < ActiveRecord::Base
    include Workflow
    include Forem::Concerns::NilUser
    include Forem::StateWorkflow

    # Used in the moderation tools partial
    attr_accessor :moderation_option

    belongs_to :topic, optional: true
    belongs_to :forem_user, :class_name => Forem.user_class.to_s, :foreign_key => :user_id, optional: true
    belongs_to :reply_to, :class_name => "Post", optional: true

    has_many :replies, :class_name  => "Post",
                       :foreign_key => "reply_to_id",
                       :dependent   => :nullify

    validates :text, :presence => true

    delegate :forum, :to => :topic

    after_create :set_topic_last_post_at
    after_commit :subscribe_replier, :if => :user_auto_subscribe? && :persisted?
    after_commit :skip_pending_review, if: :persisted?

    class << self
      def approved
        where(:state => "approved")
      end

      def approved_or_pending_review_for(user)
        user_id = if user.blank? || user.is_a?(Integer)
                    user
                  elsif user.present?
                    user.id
                  end
        if user_id
          state_column = "#{Post.table_name}.state"
          where("#{state_column} = 'approved' OR
            (#{state_column} = 'pending_review' AND #{Post.table_name}.user_id = :user_id)",
            user_id: user_id)
        else
          approved
        end
      end

      def by_created_at
        order :created_at
      end

      def pending_review
        where :state => 'pending_review'
      end

      def spam
        where :state => 'spam'
      end

      def visible
        joins(:topic).where(:forem_topics => { :hidden => false })
      end

      def topic_not_pending_review
        joins(:topic).where(:forem_topics => { :state => 'approved'})
      end

      def moderate!(posts)
        posts.each do |post_id, moderation|
          # We use find_by_id here just in case a post has been deleted.
          post = Post.find_by_id(post_id)
          post.send("#{moderation[:moderation_option]}!") if post
        end
      end
    end

    def user_auto_subscribe?
      user && user.respond_to?(:forem_auto_subscribe) && user.forem_auto_subscribe?
    end

    def owner_or_admin?(other_user)
      user == other_user || other_user.forem_admin?
    end

    def user
      User.find(user_id) if user_id.present?
    end

    protected

    def subscribe_replier
      if topic && user
        topic.subscribe_user(user.id)
      end
    end

    # Called when a post is approved.
    def approve
      approve_user
      return if notified?
      email_topic_subscribers
    end

    def email_topic_subscribers
      topic.subscriptions.includes(:subscriber).find_each do |subscription|
        subscription.send_notification(id) if subscription.subscriber != user
      end
      if reply_to.present?
        subs = topic.subscriptions.find_by(subscriber_id: reply_to.forem_user.id, topic_id: topic.id)
        Subscription.send_notification2(id, reply_to.forem_user.id) if subs.blank?
      end
      update_column(:notified, true)
    end

    def set_topic_last_post_at
      topic.update_column(:last_post_at, created_at)
    end

    def skip_pending_review
      approve! #unless user && user.forem_moderate_posts?
    end

    def approve_user
      user.update_column(:forem_state, "approved") if user && user.forem_state != "approved"
    end

    def spam
      user.update_column(:forem_state, "spam") if user
    end

  end
end
