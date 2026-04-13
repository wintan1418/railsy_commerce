require "test_helper"

class VariantFlashSaleTest < ActiveSupport::TestCase
  test "current_price_cents returns price when no flash sale" do
    variant = variants(:tshirt_master)
    assert_equal variant.price_cents, variant.current_price_cents
    assert_nil variant.sale_price_cents
    assert_not variant.on_flash_sale?
  end

  test "current_price_cents returns discounted price during running flash sale" do
    variant = variants(:laptop_master)
    expected = (variant.price_cents * 0.70).round
    assert_equal expected, variant.current_price_cents
    assert_equal expected, variant.sale_price_cents
    assert variant.on_flash_sale?
  end

  test "cart item subtotal uses flash sale price" do
    cart = carts(:guest_cart)
    variant = variants(:laptop_master)
    cart_item = cart.cart_items.create!(variant: variant, quantity: 2)
    expected_cents = variant.current_price_cents * 2
    assert_equal expected_cents, cart_item.subtotal.cents
  end

  test "create order service snapshots flash sale price to order_item" do
    cart = carts(:guest_cart)
    variant = variants(:laptop_master)
    cart.cart_items.create!(variant: variant, quantity: 1)

    result = Orders::CreateOrderService.call(
      cart: cart,
      email: "test@example.com",
      shipping_address: addresses(:customer_shipping)
    )

    assert result.success?, result.errors.inspect
    order_item = result.payload[:order].order_items.first
    assert_equal variant.current_price_cents, order_item.unit_price_cents
    assert_operator order_item.unit_price_cents, :<, variant.price_cents
  end
end
