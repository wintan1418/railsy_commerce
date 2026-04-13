class GiftCard < ApplicationRecord
  include MoneyRails::ActiveRecord::Monetizable

  belongs_to :purchaser, class_name: "User", optional: true
  has_many :gift_card_transactions, dependent: :destroy

  monetize :initial_balance_cents
  monetize :balance_cents

  validates :code, presence: true, uniqueness: { case_sensitive: false }
  validates :initial_balance_cents, numericality: { greater_than: 0 }
  validates :balance_cents, numericality: { greater_than_or_equal_to: 0 }

  normalizes :code, with: ->(c) { c.strip.upcase }

  before_validation :generate_code, on: :create
  before_validation :set_initial_balance, on: :create

  scope :active, -> { where(active: true) }
  scope :valid_now, -> {
    where("expires_at IS NULL OR expires_at >= ?", Time.current)
  }

  def expired?
    expires_at.present? && expires_at < Time.current
  end

  def depleted?
    balance_cents.to_i <= 0
  end

  def available?
    active? && !expired? && !depleted?
  end

  def usable_amount_cents(total_cents)
    return 0 unless available?
    [ balance_cents, total_cents ].min
  end

  def redeem!(amount_cents, order:)
    raise ArgumentError, "Amount exceeds balance" if amount_cents > balance_cents

    transaction do
      update!(balance_cents: balance_cents - amount_cents)
      gift_card_transactions.create!(
        order: order,
        amount_cents: amount_cents,
        kind: "redeem",
        occurred_at: Time.current
      )
    end
  end

  private

  def generate_code
    return if code.present?
    loop do
      self.code = "GC-#{SecureRandom.alphanumeric(10).upcase}"
      break unless GiftCard.exists?(code: code)
    end
  end

  def set_initial_balance
    self.balance_cents ||= initial_balance_cents
  end
end
