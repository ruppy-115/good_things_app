class AddFriendCodeToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :friend_code, :string
    add_index :users, :friend_code, unique: true
  end
end
