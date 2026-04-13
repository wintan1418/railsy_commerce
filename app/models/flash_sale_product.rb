class FlashSaleProduct < ApplicationRecord
  belongs_to :flash_sale
  belongs_to :product

  validates :product_id, uniqueness: { scope: :flash_sale_id }
  validates :sale_price_cents, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
end
