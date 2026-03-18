require "test_helper"

class ReturnItemTest < ActiveSupport::TestCase
  test "valid return item" do
    ri = ReturnItem.new(
      return_request: ReturnRequest.find_by(status: "requested"),
      order_item: order_items(:tshirt_order_item),
      quantity: 1
    )
    assert ri.valid?
  end

  test "requires quantity greater than 0" do
    ri = ReturnItem.new(
      return_request: ReturnRequest.find_by(status: "requested"),
      order_item: order_items(:tshirt_order_item),
      quantity: 0
    )
    assert_not ri.valid?
    assert_includes ri.errors[:quantity], "must be greater than 0"
  end

  test "belongs to return_request" do
    ri = return_items(:return_item_one)
    assert_equal ReturnRequest.find_by(status: "requested"), ri.return_request
  end

  test "belongs to order_item" do
    ri = return_items(:return_item_one)
    assert_equal order_items(:tshirt_order_item), ri.order_item
  end
end
