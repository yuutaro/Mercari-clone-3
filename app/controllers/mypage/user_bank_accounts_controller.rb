class Mypage::UserBankAccountsController < ApplicationController
  before_action :authenticate_user!

  def index
    #現在のユーザーのレコードを探し代入
    @user_bank_accounts = current_user.user_bank_accounts
  end

  def new
    #現在のユーザーの銀行口座の作成
    @user_bank_account = current_user.user_bank_accounts.build
  end

  def create
    #入力された属性を参照して、銀行口座を代入
    @user_bank_account = current_user.user_bank_accounts.build(user_bank_account_params)
    #銀行口座情報を保存
    if @user_bank_account.save
      redirect_to mypage_user_bank_accounts_path, notice: "銀行口座の登録に成功しました"
    else
      flash.now.alert = "銀行口座の登録に失敗しました"
      render :new
    end
  end

  def edit
    #現在のユーザーの銀行口座レコードを探し代入
    @user_bank_account = current_user.user_bank_accounts.find(params[:id])
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
