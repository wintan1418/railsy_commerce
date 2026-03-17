module Admin
  class DashboardController < BaseController
    def show
      @total_revenue = Order.where.not(status: :cancelled).sum(:total_cents)
      @order_count = Order.count
      @product_count = Product.count
      @customer_count = User.customer.count
      @recent_orders = Order.recent.limit(10).includes(:user)
    end
  end
end
