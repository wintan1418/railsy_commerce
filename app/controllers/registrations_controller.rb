class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_registration_url, alert: "Try again later." }

  before_action :capture_referral_code

  def new
    @user = User.new
    @referrer = lookup_referrer
  end

  def create
    @user = User.new(user_params)
    @user.referred_by = lookup_referrer

    if @user.save
      session.delete(:referral_code)
      start_new_session_for @user
      UserMailer.welcome(@user).deliver_later
      redirect_to root_path, notice: "Welcome to RailsyCommerce!"
    else
      @referrer = lookup_referrer
      render :new, status: :unprocessable_entity
    end
  end

  private

  def capture_referral_code
    code = params[:ref].to_s.strip.upcase
    session[:referral_code] = code if code.present? && User.exists?(referral_code: code)
  end

  def lookup_referrer
    code = session[:referral_code]
    return nil unless code.present?
    User.find_by(referral_code: code)
  end

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :first_name, :last_name, :role, :vendor_name, :phone)
  end
end
