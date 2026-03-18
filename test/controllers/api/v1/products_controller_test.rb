require "test_helper"

module Api
  module V1
    class ProductsControllerTest < ActionDispatch::IntegrationTest
      test "index returns products" do
        get api_v1_products_url, as: :json
        assert_response :success
        body = JSON.parse(response.body)
        assert body["products"].is_a?(Array)
        assert body["meta"]["total"].positive?
      end

      test "index supports pagination" do
        get api_v1_products_url(page: 1, per_page: 1), as: :json
        assert_response :success
        body = JSON.parse(response.body)
        assert_equal 1, body["products"].length
        assert_equal 1, body["meta"]["per_page"]
      end

      test "show returns a product with variants" do
        product = products(:tshirt)
        get api_v1_product_url(product.slug), as: :json
        assert_response :success
        body = JSON.parse(response.body)
        assert_equal product.name, body["product"]["name"]
        assert body["product"]["variants"].is_a?(Array)
      end

      test "show returns 404 for non-existent product" do
        get api_v1_product_url("non-existent"), as: :json
        assert_response :not_found
      end

      test "does not require authentication" do
        get api_v1_products_url, as: :json
        assert_response :success
      end
    end
  end
end
