require "test_helper"

class Carts::AddItemServiceTest < ActiveSupport::TestCase
  test "adds new item to cart" do
    cart = carts(:guest_cart)
    variant = variants(:tshirt_master)

    result = Carts::AddItemService.call(cart: cart, variant: variant, quantity: 1)

    assert result.success?
    assert_equal 1, result.payload[:cart_item].quantity
    assert_equal variant, result.payload[:cart_item].variant
  end

  test "increments quantity for existing item" do
    cart = carts(:customer_cart)
    variant = variants(:tshirt_master)

    result = Carts::AddItemService.call(cart: cart, variant: variant, quantity: 3)

    assert result.success?
    assert_equal 5, result.payload[:cart_item].quantity # was 2, now 5
  end

  test "fails with zero quantity" do
    cart = carts(:guest_cart)
    variant = variants(:tshirt_master)

    result = Carts::AddItemService.call(cart: cart, variant: variant, quantity: 0)

    assert result.failure?
    assert_includes result.errors, "Quantity must be positive"
  end

  test "fails for draft product" do
    cart = carts(:guest_cart)
    draft = products(:draft_product)
    variant = draft.variants.create!(price_cents: 1000, is_master: true)

    result = Carts::AddItemService.call(cart: cart, variant: variant, quantity: 1)

    assert result.failure?
    assert_includes result.errors, "Product is not available"
  end
end
