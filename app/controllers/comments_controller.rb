class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @item = Item.find(params[:item_id])
    comment = @item.comments.build(comment_params)
    comment.user_id = current_user.id

    if comment.save
      redirect_to item_path(@item), notice: 'コメントを投稿しました'
    else
      flash.now[:alert] = 'コメントの投稿に失敗しました'
      render 'items/show'
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    redirect_to item_path(comment.item), notice: 'コメントを削除しました'
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
