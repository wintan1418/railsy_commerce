class Variant < ApplicationRecord
  include MoneyRails::ActiveRecord::Monetizable

  belongs_to :product
  has_many :option_value_variants, dependent: :destroy
  has_many :option_values, through: :option_value_variants
  has_many :stock_items, dependent: :destroy

  has_many_attached :images

  monetize :price_cents
  monetize :compare_at_price_cents, allow_nil: true
  monetize :cost_price_cents, allow_nil: true

  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }

  scope :masters, -> { where(is_master: true) }
  scope :non_masters, -> { where(is_master: false) }
  scope :ordered, -> { order(:position) }

  def options_text
    option_values.includes(:option_type).map { |ov|
      "#{ov.option_type.presentation}: #{ov.presentation}"
    }.join(", ")
  end

  def total_stock
    stock_items.sum(:available_quantity)
  end

  def in_stock?
    stock_items.any? { |si| si.available_quantity > 0 || si.backorderable? }
  end

  def on_sale?
    compare_at_price_cents.present? && compare_at_price_cents > price_cents
  end
end
