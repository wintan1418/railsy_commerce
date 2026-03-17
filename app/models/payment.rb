class Payment < ApplicationRecord
  include MoneyRails::ActiveRecord::Monetizable

  belongs_to :order

  monetize :amount_cents

  enum :status, {
    pending: "pending",
    processing: "processing",
    completed: "completed",
    failed: "failed",
    refunded: "refunded"
  }

  validates :amount_cents, numericality: { greater_than: 0 }
  validates :payment_method, presence: true
  validates :status, presence: true
end
