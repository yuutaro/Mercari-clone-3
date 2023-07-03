class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def new
    @item = current_user.items.build
  end

  def create
    @item = @current_user.items.build(item_params)

    if @item.save
      redirect_to @item, notice: "商品の作成に成功しました"
    else
      flash.now.alart = "商品の作成に失敗しました"
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def item_params
    params.require(:item).parmit(
      :item_category_id,
      :item_condition_id,
      :name,
      :description,
      :shipping_payer_type_id,
      :prefecture_id,
      :shipping_day_type_id,
      :price,
      :images_cache,
      images: []
    )
  end
end
