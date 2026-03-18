require "test_helper"

module Admin
  class SetupControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
      # Ensure setup is not complete for these tests
      config = StoreConfig.find_by(key: "setup_complete")
      config&.update(value: "false")
    end

    test "show setup wizard step 1" do
      get admin_setup_url
      assert_response :success
    end

    test "show setup wizard with step param" do
      get admin_setup_url(step: 2)
      assert_response :success
    end

    test "redirects to dashboard if setup already complete" do
      StoreConfig.set("setup_complete", "true")
      get admin_setup_url
      assert_redirected_to admin_root_url
    end

    test "update step 1 saves store basics" do
      patch admin_setup_url, params: {
        step: 1,
        store_name: "Test Store",
        store_email: "test@example.com",
        store_currency: "EUR"
      }
      assert_redirected_to admin_setup_url(step: 2)
      assert_equal "Test Store", StoreConfig.get("store_name")
      assert_equal "test@example.com", StoreConfig.get("store_email")
      assert_equal "EUR", StoreConfig.get("store_currency")
    end

    test "update step 2 saves payment settings" do
      patch admin_setup_url, params: {
        step: 2,
        stripe_publishable_key: "pk_test_123",
        stripe_secret_key: "sk_test_456"
      }
      assert_redirected_to admin_setup_url(step: 3)
      assert_equal "pk_test_123", StoreConfig.get("stripe_publishable_key")
    end

    test "update step 3 creates shipping method" do
      patch admin_setup_url, params: {
        step: 3,
        shipping_name: "Express",
        shipping_price: "14.99",
        min_days: 1,
        max_days: 3
      }
      assert_redirected_to admin_setup_url(step: 4)
      sm = ShippingMethod.find_by(name: "Express")
      assert_not_nil sm
      assert_equal 1499, sm.price_cents
    end

    test "update step 5 marks setup as complete" do
      patch admin_setup_url, params: { step: 5 }
      assert_redirected_to admin_root_url
      assert_equal "true", StoreConfig.get("setup_complete")
    end

    test "requires admin authentication" do
      delete session_url
      get admin_setup_url
      assert_response :redirect
    end
  end
end
