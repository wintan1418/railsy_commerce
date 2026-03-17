require "test_helper"

module Account
  class ProfileControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:customer)
    end

    test "show profile" do
      get account_profile_url
      assert_response :success
    end

    test "update profile" do
      patch account_profile_url, params: { user: { first_name: "Updated" } }
      assert_redirected_to account_profile_url
      assert_equal "Updated", users(:customer).reload.first_name
    end
  end
end
