require "test_helper"

class Orders::CreateOrderServiceCouponTest < ActiveSupport::TestCase
  test "applies coupon to order and creates usage record" do
    cart = carts(:customer_cart)
    address = addresses(:customer_shipping)
    shipping = shipping_methods(:standard)
    user = users(:customer)

    result = Orders::CreateOrderService.call(
      cart: cart,
      email: "test@example.com",
      shipping_address: address,
      shipping_method: shipping,
      user: user,
      coupon_code: "SAVE20"
    )

    assert result.success?, result.errors.inspect
    order = result.payload[:order]
    # customer_cart has 2x tshirt @ 2999 = 5998
    assert_equal 5998, order.subtotal_cents
    # 20% off = 1200 (rounded from 1199.6)
    assert_equal 1200, order.discount_total_cents
    assert_equal discounts(:percentage_discount), order.discount
    # total = 5998 - 1200 + 999 shipping = 5797
    assert_equal 5797, order.total_cents

    usage = DiscountUsage.last
    assert_equal user, usage.user
    assert_equal order, usage.order
    assert_equal discounts(:percentage_discount), usage.discount
  end

  test "ignores invalid coupon silently and creates order without discount" do
    cart = carts(:customer_cart)
    result = Orders::CreateOrderService.call(
      cart: cart,
      email: "test@example.com",
      shipping_address: addresses(:customer_shipping),
      coupon_code: "BOGUS"
    )
    assert result.success?
    assert_equal 0, result.payload[:order].discount_total_cents
  end

  test "no coupon works as before" do
    cart = carts(:customer_cart)
    result = Orders::CreateOrderService.call(
      cart: cart,
      email: "test@example.com",
      shipping_address: addresses(:customer_shipping)
    )
    assert result.success?
    assert_equal 0, result.payload[:order].discount_total_cents
  end
end
