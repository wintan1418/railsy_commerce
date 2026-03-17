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
end
