require "test_helper"

class Inventory::ReleaseStockServiceTest < ActiveSupport::TestCase
  test "releases reserved stock" do
    variant = variants(:tshirt_small_red)
    stock_item = stock_items(:tshirt_small_red_stock)

    result = Inventory::ReleaseStockService.call(variant: variant, quantity: 3)

    assert result.success?
    stock_item.reload
    assert_equal 53, stock_item.available_quantity
    assert_equal 2, stock_item.reserved_quantity
  end

  test "does not release more than reserved" do
    variant = variants(:tshirt_small_red)
    stock_item = stock_items(:tshirt_small_red_stock)

    result = Inventory::ReleaseStockService.call(variant: variant, quantity: 100)

    assert result.success?
    stock_item.reload
    assert_equal 55, stock_item.available_quantity
    assert_equal 0, stock_item.reserved_quantity
  end
end
