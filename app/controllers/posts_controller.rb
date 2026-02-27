class PostsController < ApplicationController
  def index
    @current_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @start_date = @current_date.beginning_of_week(:sunday)

    # 共通の絞り込み
    base_posts = Post.where(created_at: @current_date.all_day).includes(:user)

    if params[:filter] == "friends"
      # 1. フレンドのIDリストを取得し、自分のIDも追加する（自分の投稿も見れるようにするため）
      target_user_ids = current_user.friends.pluck(:id) + [ current_user.id ]
      # 2. フレンドと自分の投稿のうち、「公開」または「フレンド限定」のものを取得
      @posts = base_posts.where(user_id: target_user_ids, status: [ :published, :friends_only ])
    else
      # published のステータスを取得
      @posts = base_posts.status_published
    end
    @posts = @posts.order(created_at: :desc)
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
    params.require(:post).permit(:body, :status)
  end
end
