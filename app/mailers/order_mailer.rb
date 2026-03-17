class OrderMailer < ApplicationMailer
  def confirmation(order)
    @order = order
    mail(
      to: @order.email,
      subject: "Order Confirmed - #{@order.number}"
    )
  end

  def shipped(order, shipment)
    @order = order
    @shipment = shipment
    mail(
      to: @order.email,
      subject: "Your Order Has Shipped - #{@order.number}"
    )
  end
end
