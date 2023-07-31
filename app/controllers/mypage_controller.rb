class MypageController < ApplicationController
  before_action :authenticate_user!
  
  def index
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path(current_user), notice: "プロフィールの更新に成功しました"
    else
      flash.now.alert = "プロフィールの更新に失敗しました"
      render :edit
    end
  end

  private

  def user_params
    #profile_attributes内に含まれ、許可したいパラメータを定義
    params.require(:user).permit(
      :nickname,
      profile_attributes: %i[avatar avatar_cache introduction]
    )
  end
end
