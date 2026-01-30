class PostsController < ApplicationController
    def index
        @posts = Post.includes(:user)
    end

    def new
        @post = Post.new
    end

    def create
        @post = current_user.posts.build(post_params)
        if @post.save
            redirect_to posts_path, success: "今日の記録を作成しました"
        else
            flash.now[:danger] = "記録を作成できませんでした"
            render :new, status: :unprocessable_entity
        end
    end

    private

    def post_params
        params.require(:post).permit(:body)
    end
end
