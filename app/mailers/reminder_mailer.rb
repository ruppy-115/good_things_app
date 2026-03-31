class ReminderMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reminder_mailer.daily_notification.subject
  #
  def daily_notification(user)
    @user = user
    mail(to: @user.email, subject: "【ぽかぽか日記】日記を書く時間ですよ")
  end
end
