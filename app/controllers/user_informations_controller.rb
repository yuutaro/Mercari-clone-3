class UserInformationsController < ApplicationController
  before_action :authenticate_user!

  def new
    # has_oneアソシエーションの場合、current_userのidがあらかじめ代入されている
    @user_information = current_user.build_user_information
  end

  def create
    @user_information = current_user.build_user_information(user_information_params)
    if @user_information.save
      redirect_to new_user_mobile_phone_path, notice: "ユーザー情報を登録しました"
    else
      flash.now[:alert] = "ユーザー情報の登録に失敗しました"
      render :new
    end
  end

  private

  # ストロングパラメーター
  def user_information_params
    params.require(:user_information).permit(
      :family_name,
      :given_name,
      :family_name_kana,
      :given_name_kana,
      :birth_date
    )
  end
end
