require "test_helper"

module Admin
  class DashboardControllerTest < ActionDispatch::IntegrationTest
    test "requires admin" do
      get admin_root_url
      assert_redirected_to new_session_url
    end

    test "customer cannot access" do
      sign_in_as users(:customer)
      get admin_root_url
      assert_redirected_to root_url
    end

    test "admin can access dashboard" do
      sign_in_as users(:admin)
      get admin_root_url
      assert_response :success
      assert_select "h1", "Dashboard"
    end
  end
end
