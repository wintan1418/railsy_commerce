class StockItem < ApplicationRecord
  belongs_to :stock_location
  belongs_to :variant

  validates :available_quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :reserved_quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :variant_id, uniqueness: { scope: :stock_location_id }

  def in_stock?
    available_quantity > 0 || backorderable?
  end

  def can_reserve?(quantity)
    available_quantity >= quantity || backorderable?
  end
end
