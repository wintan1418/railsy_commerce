require "test_helper"

class Discounts::ApplyDiscountServiceTest < ActiveSupport::TestCase
  test "applies percentage discount" do
    order = orders(:pending_order)
    result = Discounts::ApplyDiscountService.call(order: order, code: "SAVE20")

    assert result.success?
    order.reload
    assert_equal discounts(:percentage_discount), order.discount
    assert order.discount_total_cents > 0
  end

  test "applies fixed discount" do
    order = orders(:pending_order)
    result = Discounts::ApplyDiscountService.call(order: order, code: "FLAT10")

    assert result.success?
    assert_equal 1000, result.payload[:savings]
  end

  test "rejects invalid code" do
    order = orders(:pending_order)
    result = Discounts::ApplyDiscountService.call(order: order, code: "INVALID")

    assert result.failure?
    assert_includes result.errors, "Invalid discount code"
  end

  test "rejects expired code" do
    order = orders(:pending_order)
    result = Discounts::ApplyDiscountService.call(order: order, code: "EXPIRED")

    assert result.failure?
    assert_includes result.errors, "This code has expired"
  end
end
