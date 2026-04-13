require "test_helper"

class Orders::CreateOrderServiceDigitalTest < ActiveSupport::TestCase
  test "creates DigitalDownload for digital products" do
    products(:tshirt).update!(is_digital: true)
    cart = carts(:customer_cart)

    result = Orders::CreateOrderService.call(
      cart: cart,
      email: "test@example.com",
      shipping_address: addresses(:customer_shipping)
    )

    assert result.success?
    order = result.payload[:order]
    item = order.order_items.first
    assert item.digital?
    assert item.digital_download.present?
    assert item.digital_download.access_token.present?
  end

  test "does not create DigitalDownload for physical products" do
    cart = carts(:customer_cart)

    result = Orders::CreateOrderService.call(
      cart: cart,
      email: "test@example.com",
      shipping_address: addresses(:customer_shipping)
    )

    assert result.success?
    assert_nil result.payload[:order].order_items.first.digital_download
  end
end
