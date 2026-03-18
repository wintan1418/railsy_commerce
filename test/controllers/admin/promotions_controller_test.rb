require "test_helper"

module Admin
  class PromotionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index lists promotions" do
      get admin_promotions_url
      assert_response :success
      assert_select "table"
    end

    test "new promotion form" do
      get new_admin_promotion_url
      assert_response :success
    end

    test "create promotion" do
      assert_difference "Promotion.count", 1 do
        post admin_promotions_url, params: {
          promotion: {
            name: "Summer Sale",
            promotion_type: "free_shipping",
            active: true
          }
        }
      end
      assert_redirected_to admin_promotions_url
    end

    test "edit promotion form" do
      get edit_admin_promotion_url(promotions(:free_shipping_promo))
      assert_response :success
    end

    test "update promotion" do
      patch admin_promotion_url(promotions(:free_shipping_promo)), params: {
        promotion: { name: "Updated Free Shipping" }
      }
      assert_redirected_to admin_promotions_url
      assert_equal "Updated Free Shipping", promotions(:free_shipping_promo).reload.name
    end

    test "delete promotion" do
      assert_difference "Promotion.count", -1 do
        delete admin_promotion_url(promotions(:inactive_promo))
      end
      assert_redirected_to admin_promotions_url
    end
  end
end
