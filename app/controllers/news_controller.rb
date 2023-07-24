class NewsController < ApplicationController
  before_action :authenticate_user!

  def index
    #ニュースを全件取得する
    @news = News.all
  end

  def show
    #ニュースを1件取得する
    @news = News.find(params[:id])
  end
end
