require "test_helper"

class Analytics::DashboardServiceTest < ActiveSupport::TestCase
  test "returns dashboard data" do
    result = Analytics::DashboardService.call

    assert result.success?
    assert_kind_of Integer, result.payload[:total_revenue]
    assert_kind_of Integer, result.payload[:order_count]
    assert_kind_of Integer, result.payload[:average_order_value]
    assert_kind_of Integer, result.payload[:customer_count]
    assert_respond_to result.payload[:recent_orders], :each
    assert_kind_of Hash, result.payload[:orders_by_status]
  end
end
