require "test_helper"

module Api
  module V1
    class CartControllerTest < ActionDispatch::IntegrationTest
      setup do
        @session = sessions(:customer_session)
        @headers = { "Authorization" => "Bearer #{@session.id}" }
      end

      test "show requires authentication" do
        get api_v1_cart_url, as: :json
        assert_response :unauthorized
      end

      test "show returns cart" do
        get api_v1_cart_url, headers: @headers, as: :json
        assert_response :success
        body = JSON.parse(response.body)
        assert body["cart"].is_a?(Hash)
        assert body["cart"]["items"].is_a?(Array)
      end

      test "add_item adds variant to cart" do
        variant = variants(:tshirt_master)
        post add_item_api_v1_cart_url, headers: @headers,
          params: { variant_id: variant.id, quantity: 1 }, as: :json
        assert_response :created
        body = JSON.parse(response.body)
        assert_equal "Item added", body["message"]
      end

      test "add_item returns 404 for invalid variant" do
        post add_item_api_v1_cart_url, headers: @headers,
          params: { variant_id: 999999, quantity: 1 }, as: :json
        assert_response :not_found
      end

      test "remove_item removes from cart" do
        # First add an item
        variant = variants(:laptop_master)
        post add_item_api_v1_cart_url, headers: @headers,
          params: { variant_id: variant.id, quantity: 1 }, as: :json
        assert_response :created
        cart_item_id = JSON.parse(response.body)["cart_item"]["id"]

        delete remove_item_api_v1_cart_url, headers: @headers,
          params: { cart_item_id: cart_item_id }, as: :json
        assert_response :success
      end
    end
  end
end
