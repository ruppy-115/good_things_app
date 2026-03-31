namespace :reminder do
  desc "ユーザーが設定した時刻（30分刻み）に合わせてリマインドメールを送信する"
  task send_emails: :environment do
    current_time_str = Time.zone.now.strftime("%H:%M")
    puts "[#{Time.zone.now}] Checking reminders for: #{current_time_str}"

    reminders = Reminder.where(is_enabled: true)
                        .where("TO_CHAR(remind_time AT TIME ZONE 'UTC' AT TIME ZONE 'Asia/Tokyo', 'HH24:MI') = ?", current_time_str)
                        .includes(:user)

    if reminders.empty?
      puts "No reminders to send."
      next
    end

    reminders.each do |reminder|
      begin
        ReminderMailer.daily_notification(reminder.user).deliver_now
        puts "Success: Sent to #{reminder.user.email}"
      rescue => e
        puts "Error: Failed to send to #{reminder.user.email} - #{e.message}"
      end
    end

    puts "Task finished: #{reminders.count} reminders processed."
  end
end
