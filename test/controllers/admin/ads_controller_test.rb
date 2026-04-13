require "test_helper"

module Admin
  class AdsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index groups ads by placement" do
      get admin_ads_url
      assert_response :success
    end

    test "new ad form" do
      get new_admin_ad_url
      assert_response :success
    end

    test "create ad" do
      assert_difference "Ad.count" do
        post admin_ads_url, params: {
          ad: { title: "New Promo", placement: "home_top", active: true, position: 0 }
        }
      end
      assert_redirected_to admin_ads_url
    end

    test "create with invalid placement re-renders" do
      assert_no_difference "Ad.count" do
        post admin_ads_url, params: { ad: { title: "Bad", placement: "bogus" } }
      end
      assert_response :unprocessable_entity
    end

    test "update ad" do
      patch admin_ad_url(ads(:home_mid_1)), params: { ad: { title: "Updated" } }
      assert_redirected_to admin_ads_url
      assert_equal "Updated", ads(:home_mid_1).reload.title
    end

    test "toggle flips active state" do
      ad = ads(:home_mid_1)
      post toggle_admin_ad_url(ad)
      assert_not ad.reload.active?
    end

    test "destroy ad" do
      assert_difference "Ad.count", -1 do
        delete admin_ad_url(ads(:home_mid_1))
      end
    end

    test "non-admin blocked" do
      sign_in_as users(:customer)
      get admin_ads_url
      assert_response :redirect
    end
  end
end
