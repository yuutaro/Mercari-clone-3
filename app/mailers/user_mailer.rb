class UserMailer < ApplicationMailer

  def notify_ordered(order)
    @order = order
    mail to: @order.user.email,
    subject: "【URIKAI】#{@order.item.name}の発送をお願いします "
  end
end
