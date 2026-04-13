module Account
  class ReferralsController < BaseController
    def show
      @user = Current.user
      @referral_url = new_registration_url(ref: @user.referral_code)
      @referrals = @user.referrals_made.order(created_at: :desc).includes(:referred_user, :reward_gift_card)
      @earnings_cents = @user.referral_earnings_cents
    end
  end
end
