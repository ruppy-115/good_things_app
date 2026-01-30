class MyPostsController < ApplicationController
    def index
        @posts = current_user.posts.includes(:user).order(created_at: :desc)
    end
end