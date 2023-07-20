class CommentsController < ApplicationController
  before_action :authenticate_user!

  #コメント作成メソッド
  def create
    #商品idを検索し、@itemに代入
    @item = Item.find(params[:item_id])
    #comment_paramsを元にコメントを新規作成し、代入
    comment = @item.comments.build(comment_params)
    #commentモデルのuser_idに現在のユーザーIDを代入
    comment.user_id = current_user.id

    #comment保存
    if comment.save
      #保存成功でcommentを代入したコメント通知メールを送信
      UserMailer.notify_comment(comment).deliver
      #商品詳細ページにリダイレクト
      redirect_to item_path(@item), notice: "コメントの作成に成功しました"
    else
      #保存失敗
      flash.now.alert = "コメントの作成に失敗しました"
      #保存せずに商品詳細ページに移動
      render "items/show"
    end
  end

  #コメント削除メソッド
  def destroy
    #現在のユーザーのコメントを探す
    comment = current_user.comments.find(params[:id])
    #そのコメントを削除する
    comment.destroy
    #商品詳細ページにリダイレクト
    redirect_to comment.item, notice: "コメントの削除に成功しました"
  end

  private

  def comment_params
    #コメントの属性を指定
    params.require(:comment).permit(:body)
  end
end
