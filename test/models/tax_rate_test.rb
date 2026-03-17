require "test_helper"

class TaxRateTest < ActiveSupport::TestCase
  test "for_address finds state-specific rate" do
    address = addresses(:customer_shipping) # NY
    rate = TaxRate.for_address(address)
    assert_equal tax_rates(:ny_tax), rate
  end

  test "calculate_tax" do
    rate = tax_rates(:ny_tax) # 8.875%
    assert_equal 888, rate.calculate_tax(10000) # $100 * 0.08875 = $8.88
  end

  test "for_address returns nil with no address" do
    assert_nil TaxRate.for_address(nil)
  end
end
