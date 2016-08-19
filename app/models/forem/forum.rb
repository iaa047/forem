module Forem
  class Forum < ApplicationRecord
    # belongs_to :user
    has_many :topics, dependent: :destroy

    before_validation :generate_permalink, on: :create
    validates :permalink, uniqueness: true
    validates :title, presence: true, length: { minimum: 5 }
    validates_presence_of [:permalink, :title, :user_id]
    # validates_associated :user

    private

    def generate_permalink
      self.permalink = self.title.parameterize if self.title
    end
  end
end
