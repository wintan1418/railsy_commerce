require "test_helper"

module Account
  class ReferralsControllerTest < ActionDispatch::IntegrationTest
    test "show renders for logged-in user" do
      sign_in_as users(:customer)
      get account_referral_url
      assert_response :success
      assert_match users(:customer).referral_code, response.body
    end

    test "redirects unauthenticated" do
      get account_referral_url
      assert_response :redirect
    end
  end
end
