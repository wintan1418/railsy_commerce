require "test_helper"

class OrderMailerTest < ActionMailer::TestCase
  test "confirmation email" do
    order = orders(:pending_order)
    email = OrderMailer.confirmation(order)

    assert_equal [order.email], email.to
    assert_includes email.subject, order.number
  end

  test "shipped email" do
    order = orders(:pending_order)
    shipment = shipments(:pending_shipment)
    email = OrderMailer.shipped(order, shipment)

    assert_equal [order.email], email.to
    assert_includes email.subject, "Shipped"
  end
end
