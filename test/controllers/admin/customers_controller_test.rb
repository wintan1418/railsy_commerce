require "test_helper"

module Admin
  class CustomersControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index lists customers" do
      get admin_customers_url
      assert_response :success
      assert_select "table"
    end

    test "index searches by name" do
      get admin_customers_url, params: { search: "Jane" }
      assert_response :success
    end

    test "index searches by email" do
      get admin_customers_url, params: { search: "customer@example.com" }
      assert_response :success
    end

    test "show customer detail" do
      get admin_customer_url(users(:customer))
      assert_response :success
    end
  end
end
