class Mypage::UserBankAccountsController < ApplicationController
  before_action :authenticate_user!

  def new
    #現在のユーザーの銀行口座の作成
    @user_bank_account = current_user.user_bank_accounts.build
  end

  def create
  end

  private

  def user_bank_account_params
    #属性の検証
    params.require(:user_bank_account).permit(
      :name,
      :kind,
      :branch_name,
      :account_number,
      :account_name
    )

  end

end
