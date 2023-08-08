class HomeController < ApplicationController
 


  def index
    #検索フォームの値を元にItemテーブルからデータを探す
    @q = Item.ransack(params[:q])
    #ransackメソッドで取得したデータ(Ransack::Searchオブジェクト)を元に、ActiveRecord_Relationオブジェクトに変換
    @items = @q.result.includes(:user).order(created_at: :desc)
  end

  

end
