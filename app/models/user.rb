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

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :role, { customer: "customer", admin: "admin" }

  validates :email_address, presence: true, uniqueness: true,
    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :role, presence: true

  def full_name
    "#{first_name} #{last_name}"
  end
end
