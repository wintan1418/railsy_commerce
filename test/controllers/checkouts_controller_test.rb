require "test_helper"

class CheckoutsControllerTest < ActionDispatch::IntegrationTest
  test "show redirects to cart when empty" do
    get checkout_url
    assert_redirected_to cart_url
  end

  test "show renders checkout when cart has items" do
    post cart_items_url, params: { variant_id: variants(:tshirt_master).id, quantity: 1 }
    get checkout_url
    assert_response :success
  end

  test "update address step" do
    post cart_items_url, params: { variant_id: variants(:tshirt_master).id, quantity: 1 }
    patch checkout_url, params: {
      step: "address",
      email: "guest@example.com",
      address: {
        first_name: "Test", last_name: "User",
        address_line_1: "123 Main St", city: "New York",
        state: "NY", postal_code: "10001", country_code: "US"
      }
    }
    assert_response :success
  end

  test "confirm shows order" do
    get confirm_checkout_url(order_number: orders(:pending_order).number)
    assert_response :success
  end

  test "apply valid coupon stores in session" do
    post cart_items_url, params: { variant_id: variants(:tshirt_master).id, quantity: 2 }
    post apply_coupon_checkout_url, params: { code: "SAVE20" }
    assert_redirected_to checkout_url
    follow_redirect!
    assert_match(/SAVE20/, response.body)
  end

  test "apply invalid coupon shows error" do
    post cart_items_url, params: { variant_id: variants(:tshirt_master).id, quantity: 1 }
    post apply_coupon_checkout_url, params: { code: "NOPE" }
    follow_redirect!
    assert_match(/Invalid discount code/, response.body)
  end

  test "remove coupon clears session" do
    post cart_items_url, params: { variant_id: variants(:tshirt_master).id, quantity: 2 }
    post apply_coupon_checkout_url, params: { code: "SAVE20" }
    delete remove_coupon_checkout_url
    assert_redirected_to checkout_url
    follow_redirect!
    assert_no_match(/SAVE20 applied/, response.body)
  end
end
