require "test_helper"

module Account
  class OrdersControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:customer)
    end

    test "index shows customer orders" do
      get account_orders_url
      assert_response :success
    end

    test "show order" do
      get account_order_url(orders(:pending_order))
      assert_response :success
    end

    test "requires authentication" do
      delete session_url
      get account_orders_url
      assert_redirected_to new_session_url
    end
  end
end
