class Shipment < ApplicationRecord
  belongs_to :order
  belongs_to :shipping_method

  enum :status, {
    pending: "pending",
    shipped: "shipped",
    delivered: "delivered"
  }

  validates :status, presence: true

  def ship!(tracking_number: nil)
    update!(status: :shipped, tracking_number: tracking_number, shipped_at: Time.current)
  end

  def deliver!
    update!(status: :delivered, delivered_at: Time.current)
  end
end
