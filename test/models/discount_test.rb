require "test_helper"

class DiscountTest < ActiveSupport::TestCase
  test "normalizes code to uppercase" do
    discount = Discount.new(code: "  save20  ")
    assert_equal "SAVE20", discount.code
  end

  test "expired?" do
    assert discounts(:expired_discount).expired?
    assert_not discounts(:percentage_discount).expired?
  end

  test "calculate_discount for percentage" do
    discount = discounts(:percentage_discount)
    assert_equal 2000, discount.calculate_discount(10000) # 20% of $100
  end

  test "calculate_discount for fixed amount" do
    discount = discounts(:fixed_discount)
    assert_equal 1000, discount.calculate_discount(10000) # $10 off $100
  end

  test "fixed amount cannot exceed subtotal" do
    discount = discounts(:fixed_discount)
    assert_equal 500, discount.calculate_discount(500) # $10 off $5 = capped at $5
  end

  test "valid_now scope" do
    valid = Discount.valid_now
    assert_not_includes valid, discounts(:expired_discount)
    assert_includes valid, discounts(:percentage_discount)
  end
end
