module Orders
  class CreateOrderService < ApplicationService
    def initialize(cart:, email:, shipping_address:, billing_address: nil, shipping_method: nil, user: nil, coupon_code: nil)
      @cart = cart
      @email = email
      @shipping_address = shipping_address
      @billing_address = billing_address || shipping_address
      @shipping_method = shipping_method
      @user = user
      @coupon_code = coupon_code
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
          unit_price_cents = cart_item.variant.current_price_cents
          item = order.order_items.create!(
            variant: cart_item.variant,
            quantity: cart_item.quantity,
            unit_price_cents: unit_price_cents,
            total_cents: unit_price_cents * cart_item.quantity
          )
          DigitalDownload.create!(order_item: item) if item.digital?
        end

        if @shipping_method
          order.update!(shipping_total_cents: @shipping_method.price_cents)
          order.shipments.create!(shipping_method: @shipping_method, status: :pending)
        end

        apply_coupon_to(order)

        order.recalculate_totals!
        @cart.complete!
      end

      OrderMailer.confirmation(order).deliver_later

      success(order: order)
    rescue ActiveRecord::RecordInvalid => e
      failure(e.message)
    end

    private

    def apply_coupon_to(order)
      return if @coupon_code.blank?

      subtotal_cents = order.order_items.sum(:total_cents)
      result = Discounts::ValidateCodeService.call(
        code: @coupon_code,
        subtotal_cents: subtotal_cents,
        user: @user
      )
      return unless result.success?

      discount = result.payload[:discount]
      order.update!(
        discount: discount,
        discount_total_cents: result.payload[:discount_cents]
      )
      discount.discount_usages.create!(user: @user, order: order, used_at: Time.current)
      Discount.where(id: discount.id).update_all("usage_count = usage_count + 1")
    end
  end
end
