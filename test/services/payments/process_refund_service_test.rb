require "test_helper"

class Payments::ProcessRefundServiceTest < ActiveSupport::TestCase
  test "refunds completed payment" do
    payment = payments(:pending_payment)
    payment.update!(status: :completed)

    result = Payments::ProcessRefundService.call(payment: payment, reason: "Customer request", user: users(:admin))

    assert result.success?
    assert payment.reload.refunded?
    assert_equal 1, payment.order.order_events.where(event_type: "refund").count
  end

  test "rejects refund on non-completed payment" do
    payment = payments(:pending_payment)
    result = Payments::ProcessRefundService.call(payment: payment)

    assert result.failure?
    assert_includes result.errors, "Payment is not refundable"
  end
end
