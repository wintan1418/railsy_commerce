require "test_helper"

class Discounts::ValidateCodeServiceTest < ActiveSupport::TestCase
  test "validates percentage code and returns discount cents" do
    result = Discounts::ValidateCodeService.call(
      code: "SAVE20",
      subtotal_cents: 10_000,
      user: users(:customer)
    )
    assert result.success?
    assert_equal 2_000, result.payload[:discount_cents]
    assert_equal discounts(:percentage_discount), result.payload[:discount]
  end

  test "fixed discount capped at subtotal" do
    result = Discounts::ValidateCodeService.call(
      code: "FLAT10",
      subtotal_cents: 6_000,
      user: users(:customer)
    )
    assert result.success?
    assert_equal 1_000, result.payload[:discount_cents]
  end

  test "rejects blank code" do
    result = Discounts::ValidateCodeService.call(code: "", subtotal_cents: 1_000)
    assert result.failure?
    assert_includes result.errors, "Enter a code"
  end

  test "rejects unknown code" do
    result = Discounts::ValidateCodeService.call(code: "BOGUS", subtotal_cents: 1_000)
    assert result.failure?
    assert_includes result.errors, "Invalid discount code"
  end

  test "rejects expired code" do
    result = Discounts::ValidateCodeService.call(
      code: "EXPIRED",
      subtotal_cents: 10_000
    )
    assert result.failure?
    assert_includes result.errors, "This code has expired"
  end

  test "rejects when minimum order not met" do
    result = Discounts::ValidateCodeService.call(
      code: "FLAT10",
      subtotal_cents: 1_000  # below 5000 minimum
    )
    assert result.failure?
    assert_match(/Minimum order/, result.errors.first)
  end

  test "rejects when usage limit exceeded" do
    discounts(:fixed_discount).update!(usage_limit: 1, usage_count: 1)
    result = Discounts::ValidateCodeService.call(
      code: "FLAT10",
      subtotal_cents: 10_000
    )
    assert result.failure?
    assert_includes result.errors, "This code has reached its usage limit"
  end

  test "rejects when per-user limit exceeded" do
    discount = discounts(:percentage_discount)
    discount.update!(per_user_limit: 1)
    user = users(:customer)
    order = orders(:pending_order)
    discount.discount_usages.create!(user: user, order: order, used_at: Time.current)

    result = Discounts::ValidateCodeService.call(
      code: "SAVE20",
      subtotal_cents: 10_000,
      user: user
    )
    assert result.failure?
    assert_includes result.errors, "You've already used this code"
  end
end
