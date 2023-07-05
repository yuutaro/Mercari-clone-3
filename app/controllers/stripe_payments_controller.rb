class StripePaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item

  def index
  end

  def new
    @setup_intent = Stripe::SetupIntent.create(
      customer: current_user.stripe_customer.customer_id,
      payment_method_types: ['card']
    )
  end

  def create
  end

  def destroy
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end
end
