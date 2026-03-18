class ReturnItem < ApplicationRecord
  belongs_to :return_request, foreign_key: :return_id
  belongs_to :order_item

  validates :quantity, numericality: { greater_than: 0 }
end
