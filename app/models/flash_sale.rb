class FlashSale < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :flash_sale_products, dependent: :destroy
  has_many :products, through: :flash_sale_products

  validates :name, presence: true
  validates :starts_at, :ends_at, presence: true
  validates :discount_percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validate :ends_after_starts

  scope :active, -> { where(active: true) }
  scope :running, -> {
    now = Time.current
    active.where("starts_at <= ? AND ends_at >= ?", now, now)
  }
  scope :upcoming, -> {
    active.where("starts_at > ?", Time.current).order(:starts_at)
  }
  scope :ended, -> { where("ends_at < ?", Time.current) }
  scope :ordered, -> { order(starts_at: :desc) }

  def status
    return "disabled" unless active?
    now = Time.current
    return "upcoming" if starts_at > now
    return "ended"    if ends_at < now
    "running"
  end

  def running?
    status == "running"
  end

  def upcoming?
    status == "upcoming"
  end

  def time_remaining_seconds
    return 0 unless running?
    [ (ends_at - Time.current).to_i, 0 ].max
  end

  def sale_price_cents_for(product)
    fsp = flash_sale_products.find { |x| x.product_id == product.id }
    return nil unless fsp
    fsp.sale_price_cents.presence || compute_discounted_price_cents(product)
  end

  private

  def compute_discounted_price_cents(product)
    base = product.master_variant&.price_cents
    return nil unless base
    (base * (100 - discount_percentage) / 100.0).round
  end

  def ends_after_starts
    return unless starts_at && ends_at
    errors.add(:ends_at, "must be after start") if ends_at <= starts_at
  end
end
