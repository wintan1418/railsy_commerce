module Referrals
  class RewardService < ApplicationService
    REWARD_CENTS = 1000  # $10.00

    def initialize(order:)
      @order = order
    end

    def call
      user = @order.user
      return failure("No user on order") unless user

      referrer = user.referred_by
      return failure("No referrer") unless referrer

      return failure("Already rewarded") if Referral.exists?(referred_user: user, status: "rewarded")
      return failure("Not the first order") if user.orders.where.not(id: @order.id).where.not(completed_at: nil).exists?

      gift_card = GiftCard.create!(
        initial_balance_cents: REWARD_CENTS,
        balance_cents: REWARD_CENTS,
        purchaser: referrer,
        recipient_email: referrer.email_address,
        notes: "Referral reward from #{user.email_address}",
        active: true
      )

      referral = Referral.find_or_initialize_by(referrer: referrer, referred_user: user)
      referral.update!(
        triggering_order: @order,
        reward_gift_card: gift_card,
        reward_amount_cents: REWARD_CENTS,
        status: "rewarded",
        rewarded_at: Time.current
      )

      success(referral: referral, gift_card: gift_card)
    end
  end
end
