class PayerEvaluationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order

  def create
    @order.build_payer_evaluation(payer_evaluation_params)
    @order.status = :received

    if @order.save
      redirect_to order_path(@order), notice: '評価しました'
    else
      @order.restore.status!
      flash.now.alert = '評価に失敗しました'
      render 'orders/show'
    end
  end

  private

  def payer_evaluation_params
    params.require(:payer_evaluation).permit(
      :received,
      :good,
      :comment
      )
  end

  def set_order
    @order = Order.find(params[:order_id])

    return if @order.payer_id == current_user.id
    return if @order.item.user_id == current_user.id

    raise ActiveRecord::RecordNotFound
  end
end
