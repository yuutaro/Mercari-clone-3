class UserInformationsController < ApplicationController
  before_action :authenticate_user!

  def new
    # has_oneアソシエーションの場合、current_userのidがあらかじめ代入されている
    @user_information = current_user.build_user_information
  end

  def create
  end
end
