require "test_helper"

module Admin
  class OrdersControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index lists orders" do
      get admin_orders_url
      assert_response :success
    end

    test "show order" do
      get admin_order_url(orders(:pending_order))
      assert_response :success
    end

    test "update order status" do
      patch admin_order_url(orders(:pending_order)), params: {
        order: { status: "confirmed" }
      }
      assert_redirected_to admin_order_url(orders(:pending_order))
      assert_equal "confirmed", orders(:pending_order).reload.status
    end
  end
end
