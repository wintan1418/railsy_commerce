class ReturnRequest < ApplicationRecord
  self.table_name = "returns"

  include MoneyRails::ActiveRecord::Monetizable

  belongs_to :order
  belongs_to :user, optional: true
  has_many :return_items, foreign_key: :return_id, dependent: :destroy
  accepts_nested_attributes_for :return_items, reject_if: :all_blank

  enum :status, {
    requested: "requested",
    approved: "approved",
    received: "received",
    refunded: "refunded",
    rejected: "rejected"
  }

  monetize :refund_amount_cents, allow_nil: true

  validates :reason, presence: true
  validates :status, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
