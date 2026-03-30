require "test_helper"

module Storefront
  class CompareControllerTest < ActionDispatch::IntegrationTest
    test "show with product ids" do
      product1 = products(:tshirt)
      product2 = products(:laptop)
      get compare_url(ids: "#{product1.id},#{product2.id}")
      assert_response :success
      assert_select "h1", /Compare/
    end

    test "redirects when no ids" do
      get compare_url
      assert_redirected_to products_url
    end

    test "redirects when invalid ids" do
      get compare_url(ids: "999999")
      assert_redirected_to products_url
    end

    test "limits to 4 products" do
      product = products(:tshirt)
      get compare_url(ids: ([ product.id ] * 5).join(","))
      assert_response :success
    end
  end
end
