require "test_helper"

class CartItemsControllerTest < ActionDispatch::IntegrationTest
  test "add item to cart" do
    assert_difference "CartItem.count", 1 do
      post cart_items_url, params: { variant_id: variants(:laptop_master).id, quantity: 1 }
    end
    assert_response :redirect
  end

  test "remove item from cart" do
    # First add an item
    post cart_items_url, params: { variant_id: variants(:laptop_master).id, quantity: 1 }
    cart_item = CartItem.last

    assert_difference "CartItem.count", -1 do
      delete cart_item_url(cart_item)
    end
    assert_redirected_to cart_url
  end
end
