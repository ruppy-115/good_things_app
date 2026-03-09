class MyPostsController < ApplicationController
  def index
    @current_date = params[:date] ? Date.parse(params[:date]) : Date.current

    if @current_date.month <= 6
      @start_date = @current_date.beginning_of_year
    else
      @start_date = @current_date.beginning_of_year + 6.months
    end

    @posts = current_user.posts.where(created_at: @current_date.all_month).order(created_at: :desc)
  end
end
