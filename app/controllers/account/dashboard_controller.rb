module Account
  class DashboardController < BaseController
    def show
      @orders = current_user.orders.recent.limit(5).includes(:order_items)
      @total_orders = current_user.orders.count
      @total_spent = current_user.orders.where.not(status: :cancelled).sum(:total_cents)
      @wishlist_count = current_user.wishlist&.wishlist_items&.count || 0
      @addresses = current_user.addresses.limit(2)
      @recent_reviews = current_user.reviews.recent.limit(3).includes(:product)
    end
  end
end
