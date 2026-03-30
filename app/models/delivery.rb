class Delivery < ApplicationRecord
  belongs_to :order
  belongs_to :rider, class_name: "User", optional: true
  belongs_to :assigned_by, class_name: "User", optional: true

  enum :status, {
    pending: "pending",
    assigned: "assigned",
    accepted: "accepted",
    picked_up: "picked_up",
    in_transit: "in_transit",
    delivered: "delivered",
    cancelled: "cancelled"
  }

  validates :status, presence: true

  scope :available, -> { where(status: :pending) }
  scope :active, -> { where(status: %w[assigned accepted picked_up in_transit]) }
  scope :completed, -> { where(status: :delivered) }
  scope :for_rider, ->(rider) { where(rider: rider) }
  scope :recent, -> { order(created_at: :desc) }

  def accept!(rider)
    update!(
      rider: rider,
      status: :accepted,
      accepted_at: Time.current,
      rider_phone: rider.phone
    )
    log_tracking("confirmed", "Rider #{rider.display_name} has accepted your delivery.", rider)
  end

  def pick_up!(location: nil)
    update!(status: :picked_up, picked_up_at: Time.current, current_location: location)
    log_tracking("picked_up", "Your package has been picked up by the rider.", rider, location: location)
  end

  def mark_in_transit!(location: nil)
    update!(status: :in_transit, current_location: location)
    log_tracking("in_transit", "Your package is on the way to you.", rider, location: location)
  end

  def complete!(location: nil)
    update!(status: :delivered, delivered_at: Time.current, current_location: location)
    order.update!(status: :delivered)
    log_tracking("delivered", "Your package has been delivered. Thank you for shopping with us!", rider, location: location)
  end

  def cancel!(reason: nil)
    update!(status: :cancelled, rider_notes: reason)
    log_tracking("cancelled", "Delivery cancelled: #{reason}", rider)
  end

  private

  def log_tracking(status, description, user = nil, location: nil)
    order.tracking_updates.create!(
      status: status,
      description: description,
      location: location || current_location,
      updated_by: user
    )

    if order.user
      Notification.create!(
        user: order.user,
        title: "Delivery Update — #{order.number}",
        body: description,
        notification_type: "order",
        url: "/track/#{order.tracking_number || order.number}"
      )
    end
  end
end
