class Mypage::Items::CompletedController < ApplicationController
  #layoutファイルをmypageに変更
  layout "mypage"
  before_action :authenticate_user!

  #購入された商品だけを取得するメソッド
  def index
    #orderを持つitemのみ取得し、statusがcompletedのものを取得
    @items =
      current_user
        .items
        .joins(:order)
        .merge(Order.completed)
  end
end
