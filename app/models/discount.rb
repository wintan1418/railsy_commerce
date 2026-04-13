class Discount < ApplicationRecord
  has_many :orders, dependent: :nullify
  has_many :discount_usages, dependent: :destroy

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

  def not_yet_started?
    starts_at.present? && starts_at > Time.current
  end

  def usage_exceeded?
    usage_limit.present? && usage_count >= usage_limit
  end

  def minimum_met?(subtotal_cents)
    return true if minimum_order_cents.blank? || minimum_order_cents.zero?
    subtotal_cents >= minimum_order_cents
  end

  def times_used_by(user)
    return 0 unless user
    discount_usages.where(user_id: user.id).count
  end

  def per_user_limit_exceeded?(user)
    return false if per_user_limit.blank? || per_user_limit.zero?
    return false unless user
    times_used_by(user) >= per_user_limit
  end

  def calculate_discount(subtotal_cents)
    if percentage?
      (subtotal_cents * amount / 100).round
    else
      [ (amount * 100).to_i, subtotal_cents ].min
    end
  end
end
