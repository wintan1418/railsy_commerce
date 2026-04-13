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
    return true if product&.is_digital?
    stock_items.any? { |si| si.available_quantity > 0 || si.backorderable? }
  end

  def on_sale?
    compare_at_price_cents.present? && compare_at_price_cents > price_cents
  end

  def sale_price_cents
    sale = product.running_flash_sale
    return nil unless sale
    sale.sale_price_cents_for(product)
  end

  def current_price_cents
    sale_price_cents || price_cents
  end

  def current_price
    Money.new(current_price_cents, price.currency)
  end

  def on_flash_sale?
    sale_price_cents.present? && sale_price_cents < price_cents
  end
end
