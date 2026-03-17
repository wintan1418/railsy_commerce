require "test_helper"

module Admin
  class SettingsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "show settings" do
      get admin_settings_url
      assert_response :success
    end

    test "update settings" do
      patch admin_settings_url, params: {
        settings: { store_name: "My Store", store_currency: "EUR" }
      }
      assert_redirected_to admin_settings_url
      assert_equal "My Store", StoreConfig.get("store_name")
      assert_equal "EUR", StoreConfig.get("store_currency")
    end
  end
end
