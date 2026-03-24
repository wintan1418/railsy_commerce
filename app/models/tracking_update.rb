class TrackingUpdate < ApplicationRecord
  belongs_to :order
  belongs_to :updated_by, class_name: "User", optional: true

  validates :status, presence: true
  validates :description, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :chronological, -> { order(created_at: :asc) }

  STATUSES = %w[
    order_placed
    confirmed
    processing
    picked_up
    in_transit
    out_for_delivery
    delivered
    cancelled
    returned
  ].freeze

  FRIENDLY_NAMES = {
    "order_placed" => "Order Placed",
    "confirmed" => "Order Confirmed",
    "processing" => "Processing",
    "picked_up" => "Picked Up",
    "in_transit" => "In Transit",
    "out_for_delivery" => "Out for Delivery",
    "delivered" => "Delivered",
    "cancelled" => "Cancelled",
    "returned" => "Returned"
  }.freeze

  def friendly_status
    FRIENDLY_NAMES[status] || status.humanize
  end
end
