class RemoveUniqueIndexFromName < ActiveRecord::Migration[7.2]
  def change
    # 今ある「ユニーク（重複不可）」なインデックスを削除
    remove_index :users, :name

    # 「ユニークではない（重複OK）」なインデックスとして作り直す
    add_index :users, :name
  end
end
