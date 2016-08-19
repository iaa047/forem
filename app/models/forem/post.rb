module Forem
  class Post < ApplicationRecord
    belongs_to :user
    belongs_to :topic

    has_many :replied_by, class_name: 'Post', foreign_key: :reply_to_id
    #belongs_to :reply_to, class_name: 'Post'

    validates :body, presence: true

  end
end
