require "test_helper"

module Admin
  class ReturnsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index lists return requests" do
      get admin_returns_url
      assert_response :success
    end

    test "index filters by status" do
      get admin_returns_url(status: "requested")
      assert_response :success
    end

    test "show return request" do
      rr = ReturnRequest.find_by(status: "requested")
      get admin_return_url(rr)
      assert_response :success
    end

    test "update return request status" do
      rr = ReturnRequest.find_by(status: "requested")
      patch admin_return_url(rr), params: {
        return_request: { status: "approved", refund_amount_cents: 2999 }
      }
      assert_redirected_to admin_return_url(rr)
      assert_equal "approved", rr.reload.status
      assert_equal 2999, rr.refund_amount_cents
    end
  end
end
