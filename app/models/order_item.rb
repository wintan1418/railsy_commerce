class OrderItem < ApplicationRecord
  include MoneyRails::ActiveRecord::Monetizable

  belongs_to :order
  belongs_to :variant

  monetize :unit_price_cents
  monetize :total_cents

  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price_cents, numericality: { greater_than_or_equal_to: 0 }

  before_validation :calculate_total

  private

  def calculate_total
    self.total_cents = (unit_price_cents || 0) * (quantity || 0)
  end
end
