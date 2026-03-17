require "test_helper"

class Orders::CreateOrderServiceTest < ActiveSupport::TestCase
  test "creates order from cart" do
    cart = carts(:customer_cart)
    address = addresses(:customer_shipping)
    shipping = shipping_methods(:standard)

    result = Orders::CreateOrderService.call(
      cart: cart,
      email: "test@example.com",
      shipping_address: address,
      shipping_method: shipping,
      user: users(:customer)
    )

    assert result.success?
    order = result.payload[:order]
    assert order.number.start_with?("RC-")
    assert_equal "test@example.com", order.email
    assert_equal 1, order.order_items.count
    assert_equal 5998, order.subtotal_cents  # 2 x 2999
    assert_equal 999, order.shipping_total_cents
    assert_equal 6997, order.total_cents
    assert cart.reload.completed_at.present?
  end

  test "fails with empty cart" do
    cart = carts(:guest_cart)
    address = addresses(:customer_shipping)

    result = Orders::CreateOrderService.call(
      cart: cart,
      email: "test@example.com",
      shipping_address: address
    )

    assert result.failure?
    assert_includes result.errors, "Cart is empty"
  end

  test "snapshots prices at order time" do
    cart = carts(:customer_cart)
    address = addresses(:customer_shipping)

    result = Orders::CreateOrderService.call(
      cart: cart,
      email: "test@example.com",
      shipping_address: address,
      user: users(:customer)
    )

    order_item = result.payload[:order].order_items.first
    assert_equal 2999, order_item.unit_price_cents
  end
end
