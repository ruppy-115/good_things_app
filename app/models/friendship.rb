class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  enum :status, { pending: 0, accepted: 1, rejected: 2 }, prefix: true
  
  validate :prevent_reverse_friendship, on: :create

  private

  def prevent_reverse_friendship
    if Friendship.exists?(user_id: friend_id, friend_id: user_id)
      errors.add(:base, "すでに申請済み、または相手から申請が来ています")
    end
  end
end
