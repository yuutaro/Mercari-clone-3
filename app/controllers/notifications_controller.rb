class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    #お知らせを全件取得する
    @notifications = Notification.all
  end

  def show
    #お知らせを1件取得する
    @notification = Notification.find(params[:id])
  end
end
