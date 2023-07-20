class Mypage::Items::InProgressController < ApplicationController
  #layoutをmypageに変更
  layout 'mypage'

  before_action :authenticate_user!

  def index
    @items =
      current_user
        .items
        .joins(:order)
        .merge(Order.not_completed)
  end
end
