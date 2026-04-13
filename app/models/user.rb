class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  generates_token_for :password_reset, expires_in: 15.minutes do
    password_salt&.last(10)
  end
  has_many :carts, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_many :addresses, dependent: :destroy
  has_one :wishlist, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :return_requests, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # Referrals
  belongs_to :referred_by, class_name: "User", optional: true
  has_many :referrals_received, class_name: "User", foreign_key: :referred_by_id, dependent: :nullify
  has_many :referrals_made, class_name: "Referral", foreign_key: :referrer_id, dependent: :destroy
  has_one :inbound_referral, class_name: "Referral", foreign_key: :referred_user_id, dependent: :destroy

  before_validation :generate_referral_code, on: :create

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :role, { customer: "customer", vendor: "vendor", rider: "rider", admin: "admin" }

  # Vendor products
  has_many :vendor_products, class_name: "Product", foreign_key: :vendor_id, dependent: :nullify

  # Rider deliveries
  has_many :deliveries, foreign_key: :rider_id, dependent: :nullify

  validates :email_address, presence: true, uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  validates :vendor_name, presence: true, if: :vendor?

  def full_name
    "#{first_name} #{last_name}"
  end

  def referral_earnings_cents
    referrals_made.where.not(rewarded_at: nil).sum(:reward_amount_cents)
  end

  private

  def generate_referral_code
    return if referral_code.present?
    loop do
      self.referral_code = SecureRandom.alphanumeric(8).upcase
      break unless User.exists?(referral_code: referral_code)
    end
  end

  public

  def display_name
    vendor? ? (vendor_name.presence || full_name) : full_name
  end

  def oauth_user?
    provider.present?
  end

  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user

    # Check if a user with this email already exists (link accounts)
    user = find_by(email_address: auth.info.email)
    if user
      user.update!(provider: auth.provider, uid: auth.uid, avatar_url: auth.info.image)
      return user
    end

    # Create new user
    create!(
      provider: auth.provider,
      uid: auth.uid,
      email_address: auth.info.email,
      first_name: auth.info.first_name || auth.info.name&.split(" ")&.first || "User",
      last_name: auth.info.last_name || auth.info.name&.split(" ")&.last || "",
      avatar_url: auth.info.image,
      password: SecureRandom.hex(16)
    )
  end
end
