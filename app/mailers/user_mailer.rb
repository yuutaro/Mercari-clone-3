class UserMailer < ApplicationMailer

  en.user_mailer.notify_ordered.subject

  def notify_ordered(order)
    @order = order
    mail to: @order.user.email,
    subject: "【URIKAI】#{@order.item.name}の発送をお願いします "
  end
end
