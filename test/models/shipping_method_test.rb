require "test_helper"

class ShippingMethodTest < ActiveSupport::TestCase
  test "delivery_estimate" do
    standard = shipping_methods(:standard)
    assert_equal "5-7 business days", standard.delivery_estimate
  end

  test "active scope" do
    active = ShippingMethod.active
    assert_includes active, shipping_methods(:standard)
    assert_includes active, shipping_methods(:express)
  end

  test "monetizes price" do
    standard = shipping_methods(:standard)
    assert_equal Money.new(999, "USD"), standard.price
  end
end
