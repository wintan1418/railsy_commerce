require "test_helper"

module Admin
  class ThemeControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "show theme settings" do
      get admin_theme_url
      assert_response :success
      assert_select "h1", "Appearance"
    end

    test "update theme settings" do
      patch admin_theme_url, params: {
        theme: { primary_color: "#ff0000", store_display_name: "My New Store" }
      }
      assert_redirected_to admin_theme_url
      assert_equal "#ff0000", ThemeSetting.get("primary_color")
      assert_equal "My New Store", ThemeSetting.get("store_display_name")
    end

    test "update handles boolean checkboxes" do
      # When checkbox is checked, value is sent
      patch admin_theme_url, params: {
        theme: { announcement_enabled: "true" }
      }
      assert_redirected_to admin_theme_url
      assert_equal "true", ThemeSetting.get("announcement_enabled")
    end

    test "update unchecks boolean when not in params" do
      theme_settings(:announcement_enabled).update!(value: "true")
      patch admin_theme_url, params: { theme: { primary_color: "#c9a96e" } }
      assert_redirected_to admin_theme_url
      assert_equal "false", ThemeSetting.get("announcement_enabled")
    end

    test "requires admin authentication" do
      delete session_url
      get admin_theme_url
      assert_response :redirect
    end
  end
end
