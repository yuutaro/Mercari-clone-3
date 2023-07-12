class UserMailer < ApplicationMailer

  def notify_ordered(order)
    @order = order
    mail to: @order.user.email,
    subject: "【URIKAI】#{@order.item.name}の発送をお願いします "
  end

  def notify_comment(comment)
    @comment = comment
    mail to: comment.item.user.email,
    subject: "【URIKAI】#{comment.item.name}にコメントがありました"
  end
end
