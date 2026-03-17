class OrderEvent < ApplicationRecord
  belongs_to :order
  belongs_to :user, optional: true

  validates :event_type, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def self.log(order:, event_type:, data: {}, user: nil)
    create!(order: order, event_type: event_type, data: data, user: user)
  end
end
