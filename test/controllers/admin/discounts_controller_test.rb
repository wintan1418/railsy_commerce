require "test_helper"

module Admin
  class DiscountsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index" do
      get admin_discounts_url
      assert_response :success
    end

    test "create discount" do
      assert_difference "Discount.count", 1 do
        post admin_discounts_url, params: {
          discount: {
            code: "NEWCODE",
            name: "New Discount",
            discount_type: "percentage",
            amount: 15,
            active: true
          }
        }
      end
      assert_redirected_to admin_discounts_url
    end

    test "delete discount" do
      assert_difference "Discount.count", -1 do
        delete admin_discount_url(discounts(:expired_discount))
      end
    end
  end
end
