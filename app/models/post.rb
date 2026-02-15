class Post < ApplicationRecord
    validates :body, presence: true, length: { maximum: 255 }

    belongs_to :user

    enum :status, { published: 0, friends_only: 1, self_only: 2 }, prefix: true
end
