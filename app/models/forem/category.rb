require 'friendly_id'

module Forem
  class Category < ActiveRecord::Base
    extend FriendlyId
    friendly_id :name, :use => [:slugged, :finders]

    has_many :forums
    validates :name, :presence => true
    validates :position, numericality: { only_integer: true }

    scope :by_position, -> { order(:position) }

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
