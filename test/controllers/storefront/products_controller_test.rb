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

    test "index filters by brand slug" do
      products(:tshirt).update!(brand: brands(:sony))
      products(:laptop).update!(brand: brands(:apple))
      get products_url(brand: "sony")
      assert_response :success
      assert_select "h3", text: products(:tshirt).name
      assert_select "h3", text: products(:laptop).name, count: 0
    end

    test "index brand facet shows counts" do
      products(:tshirt).update!(brand: brands(:sony))
      get products_url
      assert_response :success
      assert_select "a", text: /Sony/
    end

    test "show displays product" do
      get product_url(products(:tshirt))
      assert_response :success
      assert_select "h1", products(:tshirt).name
    end
  end
end
