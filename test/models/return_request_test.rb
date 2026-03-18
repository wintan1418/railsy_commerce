require "test_helper"

class ReturnRequestTest < ActiveSupport::TestCase
  test "valid return request" do
    rr = ReturnRequest.new(
      order: orders(:pending_order),
      user: users(:customer),
      reason: "Item does not fit"
    )
    assert rr.valid?
    assert_equal "requested", rr.status
  end

  test "requires reason" do
    rr = ReturnRequest.new(order: orders(:pending_order))
    assert_not rr.valid?
    assert_includes rr.errors[:reason], "can't be blank"
  end

  test "status enum" do
    rr = ReturnRequest.find_by(status: "requested")
    assert rr.requested?

    rr2 = ReturnRequest.find_by(status: "approved")
    assert rr2.approved?
  end

  test "belongs to order" do
    rr = ReturnRequest.find_by(status: "requested")
    assert_equal orders(:pending_order), rr.order
  end

  test "has many return items" do
    rr = ReturnRequest.find_by(status: "requested")
    assert rr.return_items.any?
  end

  test "monetizes refund_amount_cents" do
    rr = ReturnRequest.find_by(status: "approved")
    assert_equal Money.new(5998, "USD"), rr.refund_amount
  end

  test "recent scope" do
    results = ReturnRequest.recent
    assert results.first.created_at >= results.last.created_at
  end

  test "user is optional" do
    rr = ReturnRequest.new(
      order: orders(:pending_order),
      reason: "Defective item"
    )
    assert rr.valid?
  end
end
