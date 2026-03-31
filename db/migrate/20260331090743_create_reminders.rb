class CreateReminders < ActiveRecord::Migration[7.2]
  def change
    create_table :reminders do |t|
      t.references :user, null: false, foreign_key: true
      t.time :remind_time
      t.boolean :is_enabled

      t.timestamps
    end
  end
end
