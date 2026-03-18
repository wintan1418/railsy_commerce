class Order < ApplicationRecord
  include MoneyRails::ActiveRecord::Monetizable

  belongs_to :user, optional: true
  belongs_to :billing_address, class_name: "Address", optional: true
  belongs_to :shipping_address, class_name: "Address", optional: true
  has_many :order_items, dependent: :destroy
  has_many :variants, through: :order_items
  belongs_to :discount, optional: true
  has_many :payments, dependent: :destroy
  has_many :shipments, dependent: :destroy
  has_many :order_events, dependent: :destroy
  has_many :return_requests, dependent: :destroy

  enum :status, {
    pending: "pending",
    confirmed: "confirmed",
    processing: "processing",
    shipped: "shipped",
    delivered: "delivered",
    cancelled: "cancelled"
  }

  monetize :subtotal_cents
  monetize :shipping_total_cents
  monetize :tax_total_cents
  monetize :discount_total_cents
  monetize :total_cents

  validates :number, presence: true, uniqueness: true
  validates :email, presence: true
  validates :status, presence: true

  before_validation :generate_number, on: :create

  scope :recent, -> { order(created_at: :desc) }

  def recalculate_totals!
    self.subtotal_cents = order_items.sum(:total_cents)
    self.total_cents = subtotal_cents + shipping_total_cents + tax_total_cents - discount_total_cents
    save!
  end

  def paid?
    payments.any? { |p| p.completed? }
  end

  private

  def generate_number
    self.number ||= "RC-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.alphanumeric(6).upcase}"
  end
end
