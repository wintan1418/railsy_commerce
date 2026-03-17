module Discounts
  class ApplyDiscountService < ApplicationService
    def initialize(order:, code:)
      @order = order
      @code = code
    end

    def call
      discount = Discount.active.find_by(code: @code.strip.upcase)

      return failure("Invalid discount code") unless discount
      return failure("This code has expired") if discount.expired?
      return failure("This code has reached its usage limit") if discount.usage_exceeded?

      if discount.minimum_order_cents.present? && @order.subtotal_cents < discount.minimum_order_cents
        min = Money.new(discount.minimum_order_cents, "USD").format
        return failure("Minimum order of #{min} required")
      end

      discount_cents = discount.calculate_discount(@order.subtotal_cents)
      @order.update!(discount: discount, discount_total_cents: discount_cents)
      @order.recalculate_totals!

      success(order: @order, discount: discount, savings: discount_cents)
    end
  end
end
