require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "generates token on create" do
    cart = Cart.create!
    assert_not_nil cart.token
    assert cart.token.length > 10
  end

  test "subtotal sums cart items" do
    cart = carts(:customer_cart)
    # 2 x $29.99 = $59.98
    assert_equal Money.new(5998, "USD"), cart.subtotal
  end

  test "item_count sums quantities" do
    cart = carts(:customer_cart)
    assert_equal 2, cart.item_count
  end

  test "empty? when no items" do
    cart = carts(:guest_cart)
    assert cart.empty?
  end

  test "complete! sets completed_at" do
    cart = carts(:customer_cart)
    cart.complete!
    assert_not_nil cart.completed_at
  end

  test "active scope excludes completed carts" do
    cart = carts(:customer_cart)
    cart.complete!
    assert_not_includes Cart.active, cart
  end

  test "belongs to user optionally" do
    guest = carts(:guest_cart)
    assert_nil guest.user
  end
end
