class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    #ユーザーIDを探し、ユーザーレコード代入
    user = User.find(params[:user_id])
    #followメソッドを用いてユーザー間の関連付け
    current_user.follow(user)
    redirect_to user_path(user), notice: "フォローに成功しました"
  end

  def destroy
    #ユーザーIDを探し、ユーザーレコード代入
    user = User.find(params[:user_id])
    #unfollowメソッドを用いてユーザー間の関連付け
    current_user.unfollow(user)
    redirect_to user_path(user), notice: "フォロー解除に成功しました"
  end
end
