class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :friend_code, presence: true, uniqueness: true

  has_many :posts, dependent: :destroy
  has_many :active_friendships, class_name: "Friendship", foreign_key: "user_id", dependent: :destroy
  has_many :passive_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy

  before_validation :generate_friend_code, on: :create

  def friends
    # 自分が申請して承認されたユーザーID
    active_friend_ids = active_friendships.status_accepted.pluck(:friend_id)
    # 相手から申請されて承認したユーザーID
    passive_friend_ids = passive_friendships.status_accepted.pluck(:user_id)
    User.where(id: active_friend_ids + passive_friend_ids)
  end

  private

  def generate_friend_code
    # 8桁のランダムな英数字を生成（重複しないようにループ処理）
    loop do
      self.friend_code = SecureRandom.alphanumeric(8).downcase
      break unless User.exists?(friend_code: friend_code)
    end
  end
end
