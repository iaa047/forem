require 'friendly_id'

module Forem
  class Forum < ActiveRecord::Base
    include Forem::Concerns::Viewable

    extend FriendlyId
    friendly_id :name, :use => [:slugged, :finders]

    belongs_to :category

    has_many :topics,     :dependent => :destroy
    has_many :posts,      :through => :topics, :dependent => :destroy
    has_many :moderators, :through => :moderator_groups, :source => :group
    has_many :moderator_groups

    validates :category, :name, :description, :presence => true
    validates :position, numericality: { only_integer: true }

    alias_attribute :title, :name

    default_scope { order(:position) }

    def last_post_for(forem_user)
      if forem_user && (forem_user.forem_admin? || moderator?(forem_user))
        posts.last
      else
        last_visible_post(forem_user)
      end
    end

    def last_visible_post(forem_user)
      posts.approved_or_pending_review_for(forem_user).last
    end

    def moderator?(user)
      user && (user.forem_group_ids & moderator_ids).any?
    end

    def to_s
      name
    end

    # Finders in FriendlyID are broken in Rails 5, will be fixed in ver `5.2.0`
    # Until then and to maintain compatibility with older code find is rewritten
    # to find by slug
    def self.find(slug)
      friendly.find(slug)
    end
  end
end
