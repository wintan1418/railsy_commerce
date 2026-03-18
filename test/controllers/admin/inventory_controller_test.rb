require "test_helper"

module Admin
  class InventoryControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "index lists stock items" do
      get admin_inventory_index_url
      assert_response :success
      assert_select "table"
    end

    test "index filters low stock" do
      get admin_inventory_index_url, params: { low_stock: "1" }
      assert_response :success
    end

    test "update stock quantity" do
      stock_item = stock_items(:tshirt_master_stock)
      patch admin_inventory_url(stock_item), params: {
        stock_item: { available_quantity: 200 }
      }
      assert_redirected_to admin_inventory_index_url
      assert_equal 200, stock_item.reload.available_quantity
    end
  end
end
