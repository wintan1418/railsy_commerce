require "test_helper"

class Referrals::RewardServiceTest < ActiveSupport::TestCase
  setup do
    @referrer = User.create!(
      email_address: "referrer@example.com",
      password: "password123",
      first_name: "R", last_name: "One", role: "customer"
    )
    @referred = User.create!(
      email_address: "friend@example.com",
      password: "password123",
      first_name: "R", last_name: "Two", role: "customer",
      referred_by: @referrer
    )
    @order = Order.create!(
      user: @referred,
      email: @referred.email_address,
      status: :pending,
      currency: "USD"
    )
  end

  test "creates gift card and referral on first order" do
    assert_difference -> { GiftCard.count } => 1, -> { Referral.count } => 1 do
      result = Referrals::RewardService.call(order: @order)
      assert result.success?
    end

    gc = GiftCard.last
    assert_equal Referrals::RewardService::REWARD_CENTS, gc.initial_balance_cents
    assert_equal @referrer, gc.purchaser

    referral = Referral.last
    assert_equal "rewarded", referral.status
    assert_equal @referrer, referral.referrer
    assert_equal @referred, referral.referred_user
  end

  test "does not reward twice for the same referred user" do
    Referrals::RewardService.call(order: @order)
    assert_no_difference "Referral.count" do
      result = Referrals::RewardService.call(order: @order)
      assert result.failure?
    end
  end

  test "no-op without referrer" do
    @referred.update_column(:referred_by_id, nil)
    result = Referrals::RewardService.call(order: @order)
    assert result.failure?
    assert_includes result.errors, "No referrer"
  end
end
