class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:new, :create]

  def new
    @order = Order.new(user: current_user, item: @item)
  end

  def create
    @order = Order.new(user: current_user, item: @item)
    if @order.pay!
      UserMailer.notify_ordered(@order).deliver
      redirect_to order_path(@order), notice: "商品を購入しました"
    else
      flash.now[:alert] = "商品の購入に失敗しました"
      render :new
    end
  end

  def show
    @order = Order.find(params[:id])

    @messagae = @order.messages.build

    return if @order.user_id == current_user.id
    return if @order.item.user_id == current_user.id

    raise ActiveRecord::RecordNotFound
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end
end
