module Orders
  class CreateOrderService < ApplicationService
    def initialize(cart:, email:, shipping_address:, billing_address: nil, shipping_method: nil, user: nil)
      @cart = cart
      @email = email
      @shipping_address = shipping_address
      @billing_address = billing_address || shipping_address
      @shipping_method = shipping_method
      @user = user
    end

    def call
      return failure("Cart is empty") if @cart.empty?

      order = nil

      ActiveRecord::Base.transaction do
        order = Order.create!(
          user: @user,
          email: @email,
          shipping_address: @shipping_address,
          billing_address: @billing_address,
          status: :pending,
          currency: "USD"
        )

        @cart.cart_items.includes(variant: :product).each do |cart_item|
          order.order_items.create!(
            variant: cart_item.variant,
            quantity: cart_item.quantity,
            unit_price_cents: cart_item.variant.price_cents,
            total_cents: cart_item.variant.price_cents * cart_item.quantity
          )
        end

        if @shipping_method
          order.update!(shipping_total_cents: @shipping_method.price_cents)
          order.shipments.create!(shipping_method: @shipping_method, status: :pending)
        end

        order.recalculate_totals!
        @cart.complete!
      end

      OrderMailer.confirmation(order).deliver_later

      success(order: order)
    rescue ActiveRecord::RecordInvalid => e
      failure(e.message)
    end
  end
end
