class Promotion < ApplicationRecord
  enum :promotion_type, {
    free_shipping: "free_shipping",
    buy_x_get_y: "buy_x_get_y",
    percentage_off_category: "percentage_off_category"
  }

  validates :name, presence: true
  validates :promotion_type, presence: true

  scope :active_promotions, -> { where(active: true) }
  scope :auto_apply, -> { where(auto_apply: true) }
  scope :valid_now, -> {
    now = Time.current
    where("(starts_at IS NULL OR starts_at <= ?) AND (expires_at IS NULL OR expires_at >= ?)", now, now)
  }

  def applicable?(order)
    return false unless active?
    return false if starts_at.present? && starts_at > Time.current
    return false if expires_at.present? && expires_at < Time.current

    case promotion_type
    when "free_shipping"
      min = conditions["minimum_total_cents"]
      min.nil? || order.subtotal_cents >= min.to_i
    when "buy_x_get_y"
      required_qty = conditions["buy_quantity"].to_i
      order.order_items.sum(:quantity) >= required_qty
    when "percentage_off_category"
      category_id = conditions["category_id"]
      return true if category_id.nil?
      order.order_items.joins(variant: :product).where(products: { category_id: category_id }).exists?
    else
      false
    end
  end

  def apply!(order)
    case promotion_type
    when "free_shipping"
      order.update!(shipping_total_cents: 0)
    when "buy_x_get_y"
      # Get the cheapest item free
      cheapest = order.order_items.order(:unit_price_cents).first
      if cheapest
        discount = cheapest.unit_price_cents
        order.update!(discount_total_cents: order.discount_total_cents + discount)
      end
    when "percentage_off_category"
      percentage = conditions["percentage"].to_f
      category_id = conditions["category_id"]
      items = order.order_items.joins(variant: :product)
      items = items.where(products: { category_id: category_id }) if category_id.present?
      discount = (items.sum(:total_cents) * percentage / 100).round
      order.update!(discount_total_cents: order.discount_total_cents + discount)
    end
    order.recalculate_totals!
  end
end
