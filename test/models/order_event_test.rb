require "test_helper"

class OrderEventTest < ActiveSupport::TestCase
  test "logs event" do
    order = orders(:pending_order)
    event = OrderEvent.log(order: order, event_type: "note", data: { message: "Test" }, user: users(:admin))

    assert event.persisted?
    assert_equal "note", event.event_type
    assert_equal "Test", event.data["message"]
  end

  test "requires event_type" do
    event = OrderEvent.new(order: orders(:pending_order))
    assert_not event.valid?
  end
end
