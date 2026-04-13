require "test_helper"

module Admin
  class BannersControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index lists banners" do
      get admin_banners_url
      assert_response :success
    end

    test "new banner form" do
      get new_admin_banner_url
      assert_response :success
    end

    test "create banner" do
      assert_difference "Banner.count" do
        post admin_banners_url, params: {
          banner: { title: "Flash Sale", subtitle: "Today only", active: true, position: 5 }
        }
      end
      assert_redirected_to admin_banners_url
    end

    test "create banner with invalid data re-renders form" do
      assert_no_difference "Banner.count" do
        post admin_banners_url, params: { banner: { title: "" } }
      end
      assert_response :unprocessable_entity
    end

    test "edit banner form" do
      get edit_admin_banner_url(banners(:spring_sale))
      assert_response :success
    end

    test "update banner" do
      banner = banners(:spring_sale)
      patch admin_banner_url(banner), params: {
        banner: { title: "Updated Title" }
      }
      assert_redirected_to admin_banners_url
      assert_equal "Updated Title", banner.reload.title
    end

    test "toggle banner active state" do
      banner = banners(:spring_sale)
      assert banner.active?
      post toggle_admin_banner_url(banner)
      assert_not banner.reload.active?
      post toggle_admin_banner_url(banner)
      assert banner.reload.active?
    end

    test "destroy banner" do
      assert_difference "Banner.count", -1 do
        delete admin_banner_url(banners(:spring_sale))
      end
      assert_redirected_to admin_banners_url
    end

    test "reorder updates positions" do
      b1 = banners(:spring_sale)
      b2 = banners(:new_arrivals)
      post reorder_admin_banners_url, params: { ids: [ b2.id, b1.id ] }
      assert_response :success
      assert_equal 0, b2.reload.position
      assert_equal 1, b1.reload.position
    end

    test "non-admin cannot access banners" do
      sign_in_as users(:customer)
      get admin_banners_url
      assert_response :redirect
    end
  end
end
