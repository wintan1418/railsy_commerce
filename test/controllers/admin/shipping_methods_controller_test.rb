require "test_helper"

module Admin
  class ShippingMethodsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index lists shipping methods" do
      get admin_shipping_methods_url
      assert_response :success
      assert_select "table"
    end

    test "new shipping method form" do
      get new_admin_shipping_method_url
      assert_response :success
    end

    test "create shipping method" do
      assert_difference "ShippingMethod.count", 1 do
        post admin_shipping_methods_url, params: {
          shipping_method: {
            name: "Overnight",
            price_cents: 4999,
            min_delivery_days: 1,
            max_delivery_days: 1,
            active: true
          }
        }
      end
      assert_redirected_to admin_shipping_methods_url
    end

    test "edit shipping method form" do
      get edit_admin_shipping_method_url(shipping_methods(:standard))
      assert_response :success
    end

    test "update shipping method" do
      patch admin_shipping_method_url(shipping_methods(:standard)), params: {
        shipping_method: { name: "Standard Ground" }
      }
      assert_redirected_to admin_shipping_methods_url
      assert_equal "Standard Ground", shipping_methods(:standard).reload.name
    end

    test "delete shipping method" do
      assert_difference "ShippingMethod.count", -1 do
        delete admin_shipping_method_url(shipping_methods(:express))
      end
      assert_redirected_to admin_shipping_methods_url
    end
  end
end
