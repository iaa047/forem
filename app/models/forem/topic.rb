require 'friendly_id'

module Forem
  class Topic < ActiveRecord::Base
    include Forem::Concerns::Viewable
    include Forem::Concerns::NilUser
    include Workflow
    include Forem::StateWorkflow

    attr_accessor :moderation_option

    extend FriendlyId
    friendly_id :subject, :use => [:slugged, :finders]

    belongs_to :forum, optional: true
    belongs_to :forem_user, :class_name => Forem.user_class.to_s, :foreign_key => :user_id, optional: true
    has_many   :subscriptions, :dependent => :destroy
    has_many   :posts, -> { order "forem_posts.created_at ASC"}, :dependent => :destroy
    accepts_nested_attributes_for :posts

    validates :subject, :presence => true, :length => { maximum: 255 }
    validates :user, :presence => true

    before_save  :set_first_post_user
    after_create :subscribe_poster
    after_create :skip_pending_review, :unless => :moderated?

    class << self
      def visible
        where(:hidden => false)
      end

      def by_pinned
        order('forem_topics.pinned DESC').
        order('forem_topics.id')
      end

      def by_most_recent_post
        order('forem_topics.last_post_at DESC').
        order('forem_topics.id')
      end

      def by_pinned_or_most_recent_post
	order('forem_topics.pinned DESC').
        order('forem_topics.last_post_at DESC').
        order('forem_topics.id')
      end

      def pending_review
        where(:state => 'pending_review')
      end

      def approved
        where(:state => 'approved')
      end

      def approved_or_pending_review_for(user)
        user_id = if user.blank? || user.is_a?(Integer)
                    user
                  elsif user.present?
                    user.id
                  end
        if user_id
          where("forem_topics.state = 'approved' OR " +
                    "(forem_topics.state = 'pending_review' AND forem_topics.user_id = ?)", user_id)
        else
          approved
        end
      end
    end

    def to_s
      subject
    end

    # Cannot use method name lock! because it's reserved by AR::Base
    def lock_topic!
      update_column(:locked, true)
    end

    def unlock_topic!
      update_column(:locked, false)
    end

    # Provide convenience methods for pinning, unpinning a topic
    def pin!
      update_column(:pinned, true)
    end

    def unpin!
      update_column(:pinned, false)
    end

    def moderate!(option)
      send("#{option}!")
    end

    # A Topic cannot be replied to if it's locked.
    def can_be_replied_to?
      !locked?
    end

    def subscribe_poster
      subscribe_user(user_id)
    end

    def subscribe_user(subscriber_id)
      if subscriber_id && !subscriber?(subscriber_id)
        subscriptions.create!(:subscriber_id => subscriber_id)
      end
    end

    def unsubscribe_user(subscriber_id)
      subscriptions_for(subscriber_id).destroy_all
    end

    def subscriber?(subscriber_id)
      subscriptions_for(subscriber_id).any?
    end

    def subscription_for(subscriber_id)
      subscriptions_for(subscriber_id).first
    end

    def subscriptions_for(subscriber_id)
      subscriptions.where(:subscriber_id => subscriber_id)
    end

    def last_page
      (self.posts.count.to_f / Forem.per_page.to_f).ceil
    end

    # Finders in FriendlyID are broken in Rails 5, will be fixed in ver `5.2.0`
    # Until then and to maintain compatibility with older code find is rewritten
    # to find by slug
    def self.find(slug)
      friendly.find(slug)
    end

    def user
      User.find(user_id) if user_id.present?
    end

    protected
    def set_first_post_user
      post = posts.first
      post.user = user
    end

    def skip_pending_review
      update_column(:state, 'approved')
    end

    def approve
      first_post = posts.by_created_at.first
      first_post.approve! unless first_post.approved?
    end

    def moderated?
      user.forem_moderate_posts?
    end
  end
end
