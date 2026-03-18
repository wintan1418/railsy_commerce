require "test_helper"

module Admin
  class TaxRatesControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index lists tax rates" do
      get admin_tax_rates_url
      assert_response :success
      assert_select "table"
    end

    test "new tax rate form" do
      get new_admin_tax_rate_url
      assert_response :success
    end

    test "create tax rate" do
      assert_difference "TaxRate.count", 1 do
        post admin_tax_rates_url, params: {
          tax_rate: {
            name: "CA State Tax",
            rate: 0.0725,
            country_code: "US",
            state: "CA",
            active: true
          }
        }
      end
      assert_redirected_to admin_tax_rates_url
    end

    test "edit tax rate form" do
      get edit_admin_tax_rate_url(tax_rates(:us_default))
      assert_response :success
    end

    test "update tax rate" do
      patch admin_tax_rate_url(tax_rates(:us_default)), params: {
        tax_rate: { rate: 0.09 }
      }
      assert_redirected_to admin_tax_rates_url
      assert_in_delta 0.09, tax_rates(:us_default).reload.rate.to_f, 0.0001
    end

    test "delete tax rate" do
      assert_difference "TaxRate.count", -1 do
        delete admin_tax_rate_url(tax_rates(:ny_tax))
      end
      assert_redirected_to admin_tax_rates_url
    end
  end
end
