require "test_helper"

class VariantTest < ActiveSupport::TestCase
  test "monetizes price" do
    variant = variants(:tshirt_master)
    assert_equal Money.new(2999, "USD"), variant.price
  end

  test "on_sale? when compare_at_price is higher" do
    variant = variants(:tshirt_master)
    assert variant.on_sale?
  end

  test "not on_sale? when no compare_at_price" do
    variant = variants(:laptop_master)
    assert_not variant.on_sale?
  end

  test "options_text" do
    variant = variants(:tshirt_small_red)
    text = variant.options_text
    assert_includes text, "Size: Small"
    assert_includes text, "Color: Red"
  end

  test "total_stock sums available quantities" do
    variant = variants(:tshirt_master)
    assert_equal 100, variant.total_stock
  end

  test "in_stock? with available quantity" do
    variant = variants(:tshirt_master)
    assert variant.in_stock?
  end

  test "in_stock? with backorderable" do
    variant = variants(:laptop_master)
    assert variant.in_stock?  # backorderable, even though available_quantity is 0
  end

  test "price must be non-negative" do
    variant = Variant.new(product: products(:tshirt), price_cents: -100)
    assert_not variant.valid?
  end
end
