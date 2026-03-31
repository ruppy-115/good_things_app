class RemindersController < ApplicationController
  def create_or_update
    @reminder = current_user.reminder || current_user.build_reminder
    if @reminder.update(reminder_params)
      redirect_to profile_path, notice: "リマインド設定を保存しました"
    else
      redirect_to profile_path, alert: "設定に失敗しました"
    end
  end

  private

  def reminder_params
    params.require(:reminder).permit(:remind_time, :is_enabled)
  end
end
