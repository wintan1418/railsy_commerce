class CartItem < ApplicationRecord
  belongs_to :cart, touch: true
  belongs_to :variant

  validates :quantity, numericality: { greater_than: 0 }
  validates :variant_id, uniqueness: { scope: :cart_id }

  def subtotal
    variant.price * quantity
  end
end
