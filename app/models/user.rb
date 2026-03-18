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

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :role, { customer: "customer", admin: "admin" }

  validates :email_address, presence: true, uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  def full_name
    "#{first_name} #{last_name}"
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
