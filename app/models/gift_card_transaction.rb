class GiftCardTransaction < ApplicationRecord
  include MoneyRails::ActiveRecord::Monetizable

  belongs_to :gift_card
  belongs_to :order, optional: true

  monetize :amount_cents

  validates :amount_cents, :kind, :occurred_at, presence: true
end
