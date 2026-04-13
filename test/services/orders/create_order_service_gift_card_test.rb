require "test_helper"

class Orders::CreateOrderServiceGiftCardTest < ActiveSupport::TestCase
  test "partial redemption deducts balance and sets gift_card_total" do
    cart = carts(:customer_cart)   # 2x tshirt @ 2999 = 5998
    gc = gift_cards(:partially_used) # balance 4000

    result = Orders::CreateOrderService.call(
      cart: cart,
      email: "test@example.com",
      shipping_address: addresses(:customer_shipping),
      gift_card_code: gc.code
    )

    assert result.success?, result.errors.inspect
    order = result.payload[:order]
    assert_equal 4000, order.gift_card_total_cents
    assert_equal gc, order.gift_card
    assert_equal 0, gc.reload.balance_cents
    # total = 5998 - 0 discount - 4000 gc + 0 shipping = 1998
    assert_equal 1998, order.total_cents
  end

  test "full payment with gift card when card >= total" do
    cart = carts(:customer_cart)   # 5998
    gc = gift_cards(:active_50)    # 5000 balance, not enough to fully cover

    result = Orders::CreateOrderService.call(
      cart: cart,
      email: "test@example.com",
      shipping_address: addresses(:customer_shipping),
      gift_card_code: gc.code
    )

    assert result.success?
    order = result.payload[:order]
    assert_equal 5000, order.gift_card_total_cents
    assert_equal 998, order.total_cents
  end

  test "expired gift card ignored silently" do
    result = Orders::CreateOrderService.call(
      cart: carts(:customer_cart),
      email: "test@example.com",
      shipping_address: addresses(:customer_shipping),
      gift_card_code: "GC-EXPIRED"
    )
    assert result.success?
    assert_equal 0, result.payload[:order].gift_card_total_cents
  end

  test "coupon + gift card stack correctly" do
    cart = carts(:customer_cart) # 5998
    result = Orders::CreateOrderService.call(
      cart: cart,
      email: "test@example.com",
      shipping_address: addresses(:customer_shipping),
      coupon_code: "SAVE20",         # 20% off 5998 = 1200 rounded
      gift_card_code: "GC-HALF"      # 4000 balance
    )

    assert result.success?, result.errors.inspect
    order = result.payload[:order]
    assert_equal 1200, order.discount_total_cents
    # subtotal after discount = 5998 - 1200 = 4798
    # gift card usable against that (no shipping) = min(4000, 4798) = 4000
    assert_equal 4000, order.gift_card_total_cents
    assert_equal 798, order.total_cents
  end
end
