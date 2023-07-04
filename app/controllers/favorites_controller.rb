class FavoritesController < ApplicationController
  before_action :authenticate_user!
  def create
    @item = Item.find(params[:item_id])
    @favorite = current_user.favorites.build(item: @item)

    if @favorite.save
      redirect_to @item, notice: "いいねしました"
    else
      flash.now.alert = "いいねに失敗しました"
      render "items/show"
    end
  end

  def destroy
  end
end
