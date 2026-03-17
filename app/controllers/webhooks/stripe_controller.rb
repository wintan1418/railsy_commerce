module Webhooks
  class StripeController < ApplicationController
    skip_before_action :require_authentication
    skip_forgery_protection

    def create
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, stripe_endpoint_secret
        )
      rescue JSON::ParserError, Stripe::SignatureVerificationError
        head :bad_request
        return
      end

      case event.type
      when "payment_intent.succeeded"
        handle_payment_success(event.data.object)
      when "payment_intent.payment_failed"
        handle_payment_failure(event.data.object)
      end

      head :ok
    end

    private

    def stripe_endpoint_secret
      Rails.application.credentials.dig(:stripe, :webhook_secret) || ENV["STRIPE_WEBHOOK_SECRET"]
    end

    def handle_payment_success(payment_intent)
      payment = Payment.find_by(stripe_payment_intent_id: payment_intent.id)
      return unless payment

      payment.update!(
        status: :completed,
        stripe_charge_id: payment_intent.latest_charge,
        response_data: payment_intent.to_h
      )

      payment.order.update!(status: :confirmed, completed_at: Time.current)
    end

    def handle_payment_failure(payment_intent)
      payment = Payment.find_by(stripe_payment_intent_id: payment_intent.id)
      return unless payment

      payment.update!(status: :failed, response_data: payment_intent.to_h)
    end
  end
end
