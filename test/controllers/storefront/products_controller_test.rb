require "test_helper"

module Storefront
  class ProductsControllerTest < ActionDispatch::IntegrationTest
    test "index shows active products" do
      get products_url
      assert_response :success
      assert_select "h3", products(:tshirt).name
    end

    test "index filters by category" do
      get products_url(category_id: categories(:clothing).id)
      assert_response :success
    end

    test "show displays product" do
      get product_url(products(:tshirt))
      assert_response :success
      assert_select "h1", products(:tshirt).name
    end
  end
end
