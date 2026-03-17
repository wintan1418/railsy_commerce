class Wishlist < ApplicationRecord
  belongs_to :user
  has_many :wishlist_items, dependent: :destroy
  has_many :variants, through: :wishlist_items

  def includes_variant?(variant)
    wishlist_items.exists?(variant: variant)
  end
end
