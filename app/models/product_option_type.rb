class ProductOptionType < ApplicationRecord
  belongs_to :product
  belongs_to :option_type

  validates :option_type_id, uniqueness: { scope: :product_id }
end
