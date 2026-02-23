class AddUniqueIndexToFriendships < ActiveRecord::Migration[7.2]
  def change
    remove_index :friendships, [:user_id, :friend_id], if_exists: true

    add_index :friendships, "LEAST(user_id, friend_id), GREATEST(user_id, friend_id)", unique: true, name: "index_friendships_on_unique_pairs"
  end
end