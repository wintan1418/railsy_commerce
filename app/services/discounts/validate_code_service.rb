module Discounts
  class ValidateCodeService < ApplicationService
    def initialize(code:, subtotal_cents:, user: nil)
      @code = code.to_s.strip.upcase
      @subtotal_cents = subtotal_cents || 0
      @user = user
    end

    def call
      return failure("Enter a code") if @code.blank?

      discount = Discount.active.find_by(code: @code)
      return failure("Invalid discount code") unless discount
      return failure("This code hasn't started yet") if discount.not_yet_started?
      return failure("This code has expired") if discount.expired?
      return failure("This code has reached its usage limit") if discount.usage_exceeded?
      return failure("You've already used this code") if discount.per_user_limit_exceeded?(@user)

      unless discount.minimum_met?(@subtotal_cents)
        min = Money.new(discount.minimum_order_cents, "USD").format
        return failure("Minimum order of #{min} required")
      end

      discount_cents = discount.calculate_discount(@subtotal_cents)
      success(discount: discount, discount_cents: discount_cents)
    end
  end
end
