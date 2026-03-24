module Vendor
  class DashboardController < BaseController
    def show
      @products = current_user.vendor_products.includes(:category, variants: :stock_items)
      @orders = Order.joins(order_items: { variant: :product })
        .where(products: { vendor_id: current_user.id })
        .distinct.recent.limit(10)
      @total_revenue = @orders.sum(:total_cents)
      @product_count = @products.count
      @order_count = @orders.count
    end
  end
end
