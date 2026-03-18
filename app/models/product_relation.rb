class ProductRelation < ApplicationRecord
  belongs_to :product
  belongs_to :related_product, class_name: "Product"

  enum :relation_type, {
    related: "related",
    cross_sell: "cross_sell",
    up_sell: "up_sell"
  }

  validates :related_product_id, uniqueness: { scope: :product_id, message: "relation already exists" }
  validates :relation_type, presence: true

  scope :ordered, -> { order(:position) }
end
