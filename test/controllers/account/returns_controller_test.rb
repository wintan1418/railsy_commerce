require "test_helper"

module Account
  class ReturnsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:customer)
    end

    test "new return form" do
      get new_account_order_return_url(orders(:pending_order))
      assert_response :success
    end

    test "create return request" do
      assert_difference "ReturnRequest.count" do
        post account_order_returns_url(orders(:pending_order)), params: {
          return_request: {
            reason: "Item damaged during shipping",
            notes: "Box was crushed"
          }
        }
      end
      assert_redirected_to account_return_url(ReturnRequest.last)
    end

    test "create return request with invalid params" do
      assert_no_difference "ReturnRequest.count" do
        post account_order_returns_url(orders(:pending_order)), params: {
          return_request: {
            reason: "",
            notes: ""
          }
        }
      end
      assert_response :unprocessable_entity
    end

    test "show return request" do
      rr = ReturnRequest.find_by(status: "requested")
      get account_return_url(rr)
      assert_response :success
    end

    test "requires authentication" do
      delete session_url
      get new_account_order_return_url(orders(:pending_order))
      assert_redirected_to new_session_url
    end
  end
end
