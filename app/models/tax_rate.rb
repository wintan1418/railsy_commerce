class TaxRate < ApplicationRecord
  validates :name, presence: true
  validates :rate, presence: true, numericality: { greater_than_or_equal_to: 0, less_than: 1 }
  validates :country_code, presence: true

  scope :active, -> { where(active: true) }

  def self.for_address(address)
    return nil unless address

    active
      .where(country_code: address.country_code)
      .where("state IS NULL OR state = ?", address.state)
      .order(Arel.sql("state IS NULL ASC"))
      .first
  end

  def calculate_tax(amount_cents)
    (amount_cents * rate).round
  end
end
