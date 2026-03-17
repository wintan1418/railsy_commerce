require "test_helper"

module Admin
  class ProductsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index lists products" do
      get admin_products_url
      assert_response :success
    end

    test "show product" do
      get admin_product_url(products(:tshirt))
      assert_response :success
    end

    test "new product form" do
      get new_admin_product_url
      assert_response :success
    end

    test "create product" do
      assert_difference "Product.count", 1 do
        post admin_products_url, params: {
          product: {
            name: "New Product",
            description: "A new product",
            status: "draft",
            category_id: categories(:clothing).id
          }
        }
      end
      assert_redirected_to admin_product_url(Product.last)
    end

    test "edit product form" do
      get edit_admin_product_url(products(:tshirt))
      assert_response :success
    end

    test "update product" do
      patch admin_product_url(products(:tshirt)), params: {
        product: { name: "Updated T-Shirt" }
      }
      assert_redirected_to admin_product_url(products(:tshirt))
      assert_equal "Updated T-Shirt", products(:tshirt).reload.name
    end

    test "delete product" do
      assert_difference "Product.count", -1 do
        delete admin_product_url(products(:draft_product))
      end
      assert_redirected_to admin_products_url
    end
  end
end
