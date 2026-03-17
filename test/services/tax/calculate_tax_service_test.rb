require "test_helper"

class Tax::CalculateTaxServiceTest < ActiveSupport::TestCase
  test "calculates tax based on shipping address" do
    order = orders(:pending_order)
    result = Tax::CalculateTaxService.call(order: order)

    assert result.success?
    assert result.payload[:tax_cents] > 0
    assert_equal tax_rates(:ny_tax), result.payload[:rate]
  end

  test "returns 0 when no address" do
    order = orders(:pending_order)
    order.update_column(:shipping_address_id, nil)

    result = Tax::CalculateTaxService.call(order: order)
    assert result.success?
    assert_equal 0, result.payload[:tax_cents]
  end
end
