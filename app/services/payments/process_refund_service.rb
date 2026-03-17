module Payments
  class ProcessRefundService < ApplicationService
    def initialize(payment:, amount_cents: nil, reason: nil, user: nil)
      @payment = payment
      @amount_cents = amount_cents || payment.amount_cents
      @reason = reason
      @user = user
    end

    def call
      return failure("Payment is not refundable") unless @payment.completed?
      return failure("Refund amount exceeds payment") if @amount_cents > @payment.amount_cents

      @payment.update!(status: :refunded)

      OrderEvent.log(
        order: @payment.order,
        event_type: "refund",
        data: { amount_cents: @amount_cents, reason: @reason, payment_id: @payment.id },
        user: @user
      )

      success(payment: @payment, refund_amount: @amount_cents)
    end
  end
end
