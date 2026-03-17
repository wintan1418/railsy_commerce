require "test_helper"

class Inventory::ReserveStockServiceTest < ActiveSupport::TestCase
  test "reserves stock successfully" do
    variant = variants(:tshirt_master)
    result = Inventory::ReserveStockService.call(variant: variant, quantity: 10)

    assert result.success?
    stock_item = result.payload[:stock_item]
    assert_equal 90, stock_item.available_quantity
    assert_equal 10, stock_item.reserved_quantity
  end

  test "fails when insufficient stock" do
    variant = variants(:tshirt_master)
    result = Inventory::ReserveStockService.call(variant: variant, quantity: 200)

    assert result.failure?
    assert_includes result.errors, "Insufficient stock"
  end

  test "fails when no stock item exists" do
    variant = Variant.create!(product: products(:tshirt), price_cents: 1000)
    result = Inventory::ReserveStockService.call(variant: variant, quantity: 1)

    assert result.failure?
    assert_includes result.errors, "No stock item found for this variant"
  end
end
