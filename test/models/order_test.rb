require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "generates order number on create" do
    order = Order.create!(email: "test@example.com", status: :pending)
    assert order.number.start_with?("RC-")
    assert_equal 18, order.number.length
  end

  test "status enum" do
    assert orders(:pending_order).pending?
    assert orders(:confirmed_order).confirmed?
  end

  test "monetizes totals" do
    order = orders(:pending_order)
    assert_equal Money.new(5998, "USD"), order.subtotal
    assert_equal Money.new(7477, "USD"), order.total
  end

  test "recalculate_totals!" do
    order = orders(:pending_order)
    order.recalculate_totals!
    assert_equal 5998, order.subtotal_cents
    assert_equal 5998 + 999 + 480 - 0, order.total_cents
  end

  test "requires email" do
    order = Order.new(status: :pending)
    assert_not order.valid?
    assert_includes order.errors[:email], "can't be blank"
  end

  test "number must be unique" do
    existing = orders(:pending_order)
    order = Order.new(number: existing.number, email: "test@example.com")
    assert_not order.valid?
    assert_includes order.errors[:number], "has already been taken"
  end

  test "belongs to user optionally" do
    order = Order.create!(email: "guest@example.com", status: :pending)
    assert_nil order.user
  end
end
