class CurrentShippingAddressesController < ApplicationController
  before_action :authenticate_user!

  #現在の配送住所更新メソッド
  def update
    #商品IDを検索し、@itemにレコードを保存
    @item = Item.find(params[:item_id])
    
    @current_shipping_address = CurrentShippingAddress.find_or_initialize_by(
      user_id: current_user.id
    )
    if @current_shipping_address.update(shipping_address_id: params[:shipping_address_id])
      redirect_to new_item_order_path(@item), notice: "配送先住所を更新しました"
    else
      flash.now.alert = "配送先住所の更新に失敗しました"
      render "shipping_addresses/index"
    end
  end
end
