namespace :reminder do
  desc "ユーザーが設定した時刻に合わせてリマインドメールを送信する"
  task send_emails: :environment do
    current_time = Time.zone.now.strftime("%H:%M")
    reminders = Reminder.where(is_enabled: true).select do |r|
      r.remind_time.strftime("%H:%M") == current_time
    end

    reminders.each do |reminder|
      ReminderMailer.daily_notification(reminder.user).deliver_now
      puts "Sent reminder to #{reminder.user.email} at #{current_time}"
    end
  end
end
