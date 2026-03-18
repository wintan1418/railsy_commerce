require "test_helper"

module Api
  module V1
    class OrdersControllerTest < ActionDispatch::IntegrationTest
      setup do
        @session = sessions(:customer_session)
      end

      test "index requires authentication" do
        get api_v1_orders_url, as: :json
        assert_response :unauthorized
      end

      test "index returns customer orders" do
        get api_v1_orders_url, headers: { "Authorization" => "Bearer #{@session.id}" }, as: :json
        assert_response :success
        body = JSON.parse(response.body)
        assert body["orders"].is_a?(Array)
      end

      test "show returns order details" do
        order = orders(:pending_order)
        get api_v1_order_url(order), headers: { "Authorization" => "Bearer #{@session.id}" }, as: :json
        assert_response :success
        body = JSON.parse(response.body)
        assert_equal order.number, body["order"]["number"]
        assert body["order"]["items"].is_a?(Array)
      end

      test "show returns 404 for other user's order" do
        # Create an order for another user
        other_order = Order.create!(email: "other@example.com", status: :pending, user: users(:admin))
        get api_v1_order_url(other_order), headers: { "Authorization" => "Bearer #{@session.id}" }, as: :json
        assert_response :not_found
      end
    end
  end
end
