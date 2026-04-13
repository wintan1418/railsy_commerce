require "test_helper"

class FlashSaleTest < ActiveSupport::TestCase
  test "requires name, starts_at, ends_at" do
    sale = FlashSale.new
    assert_not sale.valid?
    assert_includes sale.errors[:name], "can't be blank"
    assert_includes sale.errors[:starts_at], "can't be blank"
    assert_includes sale.errors[:ends_at], "can't be blank"
  end

  test "ends_at must be after starts_at" do
    sale = FlashSale.new(name: "Bad", starts_at: Time.current, ends_at: 1.hour.ago, discount_percentage: 10)
    assert_not sale.valid?
    assert_includes sale.errors[:ends_at], "must be after start"
  end

  test "discount_percentage must be 0..100" do
    sale = FlashSale.new(name: "X", starts_at: Time.current, ends_at: 1.hour.from_now, discount_percentage: 150)
    assert_not sale.valid?
  end

  test "running scope includes active sales in window" do
    assert_includes FlashSale.running, flash_sales(:running_sale)
    assert_not_includes FlashSale.running, flash_sales(:upcoming_sale)
    assert_not_includes FlashSale.running, flash_sales(:ended_sale)
    assert_not_includes FlashSale.running, flash_sales(:disabled_sale)
  end

  test "upcoming scope includes future active sales" do
    assert_includes FlashSale.upcoming, flash_sales(:upcoming_sale)
    assert_not_includes FlashSale.upcoming, flash_sales(:running_sale)
  end

  test "status returns running/upcoming/ended/disabled" do
    assert_equal "running",  flash_sales(:running_sale).status
    assert_equal "upcoming", flash_sales(:upcoming_sale).status
    assert_equal "ended",    flash_sales(:ended_sale).status
    assert_equal "disabled", flash_sales(:disabled_sale).status
  end

  test "time_remaining_seconds returns 0 when not running" do
    assert_equal 0, flash_sales(:upcoming_sale).time_remaining_seconds
    assert_equal 0, flash_sales(:ended_sale).time_remaining_seconds
  end

  test "sale_price_cents_for computes discount from master variant price" do
    sale = flash_sales(:running_sale)
    product = products(:laptop)
    # laptop master is 149900 cents, 30% off
    expected = (149900 * 0.70).round
    assert_equal expected, sale.sale_price_cents_for(product)
  end

  test "sale_price_cents_for returns nil for products not in sale" do
    sale = flash_sales(:running_sale)
    product = products(:tshirt)
    assert_nil sale.sale_price_cents_for(product)
  end
end
