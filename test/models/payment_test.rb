require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  test "valid payment" do
    payment = payments(:pending_payment)
    assert payment.valid?
    assert payment.pending?
  end

  test "monetizes amount" do
    payment = payments(:pending_payment)
    assert_equal Money.new(7477, "USD"), payment.amount
  end

  test "requires payment_method" do
    payment = Payment.new(order: orders(:pending_order), amount_cents: 100, status: :pending)
    assert_not payment.valid?
    assert_includes payment.errors[:payment_method], "can't be blank"
  end
end
