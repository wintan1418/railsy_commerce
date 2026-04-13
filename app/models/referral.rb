class Referral < ApplicationRecord
  include MoneyRails::ActiveRecord::Monetizable

  belongs_to :referrer, class_name: "User"
  belongs_to :referred_user, class_name: "User"
  belongs_to :triggering_order, class_name: "Order", optional: true
  belongs_to :reward_gift_card, class_name: "GiftCard", optional: true

  monetize :reward_amount_cents

  STATUSES = %w[pending rewarded].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :referred_user_id, uniqueness: { scope: :referrer_id }

  scope :pending, -> { where(status: "pending") }
  scope :rewarded, -> { where(status: "rewarded") }

  def rewarded?
    status == "rewarded"
  end
end
