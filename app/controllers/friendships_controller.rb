class FriendshipsController < ApplicationController
  def index
    # 1. フレンド検索の処理
    if params[:friend_code].present?
      @search_result = User.find_by(friend_code: params[:friend_code])
      if @search_result.nil?
        flash.now[:alert] = "ユーザーが見つかりませんでした。"
      elsif @search_result == current_user
        flash.now[:alert] = "自分のフレンドコードです。"
        @search_result = nil # 自分自身は検索結果から除外
      end
    end

    # 2. 申請・承認・フレンド一覧の取得
    @received_requests = current_user.passive_friendships.status_pending
    @sent_requests = current_user.active_friendships.status_pending
    @friends = current_user.friends
  end

  def create
    friend = User.find(params[:friend_id])
    @friendship = current_user.active_friendships.build(friend: friend)

    if @friendship.save
      redirect_to friendships_path, notice: "#{friend.name}さんにフレンド申請を送りました。"
    else
      # すでに申請済みの場合などのエラーハンドリング
      redirect_to friendships_path, alert: @friendship.errors.full_messages.join(", ")
    end
  end

  def update
    # 自分宛ての申請（passive_friendships）を探して承認する
    @friendship = current_user.passive_friendships.find(params[:id])
    
    if @friendship.update(status: :accepted)
      redirect_to friendships_path, notice: "フレンド申請を承認しました。"
    else
      redirect_to friendships_path, alert: "承認に失敗しました。"
    end
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    
    # 念のため、自分に関係するデータかチェックしてから削除
    if @friendship.user == current_user || @friendship.friend == current_user
      @friendship.destroy
      redirect_to friendships_path, notice: "削除しました。"
    else
      redirect_to friendships_path, alert: "権限がありません。"
    end
  end
end