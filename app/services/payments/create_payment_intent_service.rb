module Payments
  class CreatePaymentIntentService < ApplicationService
    def initialize(order:)
      @order = order
    end

    def call
      intent = Stripe::PaymentIntent.create(
        amount: @order.total_cents,
        currency: @order.currency.downcase,
        metadata: { order_id: @order.id, order_number: @order.number },
        automatic_payment_methods: { enabled: true }
      )

      payment = @order.payments.create!(
        amount_cents: @order.total_cents,
        currency: @order.currency,
        status: :pending,
        payment_method: "stripe",
        stripe_payment_intent_id: intent.id
      )

      success(
        payment: payment,
        client_secret: intent.client_secret,
        payment_intent_id: intent.id
      )
    rescue Stripe::StripeError => e
      failure(e.message)
    end
  end
end
