require "test_helper"

module Account
  class ReceiptsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:customer)
    end

    test "show receipt for order" do
      order = orders(:pending_order)
      get account_order_receipt_url(order)
      assert_response :success
      assert_select "h2", /Receipt/
    end

    test "requires authentication" do
      delete session_url
      order = orders(:pending_order)
      get account_order_receipt_url(order)
      assert_redirected_to new_session_url
    end
  end
end
