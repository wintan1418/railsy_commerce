class ShippingMethod < ApplicationRecord
  include MoneyRails::ActiveRecord::Monetizable

  has_many :shipments, dependent: :restrict_with_error

  monetize :price_cents

  validates :name, presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }

  def delivery_estimate
    if min_delivery_days && max_delivery_days
      "#{min_delivery_days}-#{max_delivery_days} business days"
    elsif min_delivery_days
      "#{min_delivery_days}+ business days"
    end
  end
end
