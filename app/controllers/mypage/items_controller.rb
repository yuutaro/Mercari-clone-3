class Mypage::ItemsController < ApplicationController
  #layoutファイルをmypageに変更
  layout "mypage"

  before_action :authenticate_user!

  #注文が完了してない商品を取り出すメソッド
  def index
    #orderのidが存在しないレコードを取得
    @items =
      current_user
        .items
        .left_joins(:order)
        .where(order: { id: nil })
  end
end
