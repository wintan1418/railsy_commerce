class Discount < ApplicationRecord
  has_many :orders, dependent: :nullify

  enum :discount_type, { percentage: "percentage", fixed_amount: "fixed_amount" }

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :discount_type, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

  normalizes :code, with: ->(c) { c.strip.upcase }

  scope :active, -> { where(active: true) }
  scope :valid_now, -> {
    now = Time.current
    where("(starts_at IS NULL OR starts_at <= ?) AND (expires_at IS NULL OR expires_at >= ?)", now, now)
  }

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  def usage_exceeded?
    usage_limit.present? && usage_count >= usage_limit
  end

  def calculate_discount(subtotal_cents)
    if percentage?
      (subtotal_cents * amount / 100).round
    else
      [ (amount * 100).to_i, subtotal_cents ].min
    end
  end
end
