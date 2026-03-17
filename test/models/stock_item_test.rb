require "test_helper"

class StockItemTest < ActiveSupport::TestCase
  test "in_stock? with available quantity" do
    stock_item = stock_items(:tshirt_master_stock)
    assert stock_item.in_stock?
  end

  test "in_stock? with backorderable" do
    stock_item = stock_items(:laptop_master_stock)
    assert stock_item.in_stock?
  end

  test "can_reserve? with sufficient stock" do
    stock_item = stock_items(:tshirt_master_stock)
    assert stock_item.can_reserve?(10)
    assert stock_item.can_reserve?(100)
    assert_not stock_item.can_reserve?(101)
  end

  test "can_reserve? with backorderable" do
    stock_item = stock_items(:laptop_master_stock)
    assert stock_item.can_reserve?(999)
  end

  test "validates non-negative quantities" do
    stock_item = stock_items(:tshirt_master_stock)
    stock_item.available_quantity = -1
    assert_not stock_item.valid?
  end
end
