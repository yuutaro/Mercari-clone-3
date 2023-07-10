class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item

  def new
    @order = Order.new(user: current_user, item: @item)
  end

  def create
    @order = Order.new(user: current_user, item: @item)
    if @order.pay!
      redirect_to root_path, notice: "商品を購入しました"
    else
      flash.now[:alert] = "商品の購入に失敗しました"
      render :new
    end
  end

  private
  
  def set_item
    @item = Item.find(params[:item_id])
  end
end
