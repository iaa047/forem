module Forem
  class Topic < ApplicationRecord
    belongs_to :user
    belongs_to :forum
    has_many :posts, dependent: :destroy

    before_validation :generate_permalink, on: :create
    validates :permalink, uniqueness: { scope: :forum_id }
    validates_presence_of [:permalink, :description, :user_id, :forum_id, :title]
    validates_associated :user, :forum


    private

    def generate_permalink
      self.permalink = self.title.parameterize if self.title
    end
  end
end
