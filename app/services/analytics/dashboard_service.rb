module Analytics
  class DashboardService < ApplicationService
    def initialize(period: 30.days)
      @period = period
      @start_date = @period.ago.beginning_of_day
    end

    def call
      success(
        total_revenue: total_revenue,
        order_count: order_count,
        average_order_value: average_order_value,
        customer_count: customer_count,
        top_products: top_products,
        recent_orders: recent_orders,
        revenue_by_day: revenue_by_day,
        orders_by_status: orders_by_status,
        low_stock_items: low_stock_items
      )
    end

    private

    def total_revenue
      Order.where.not(status: :cancelled)
        .where(created_at: @start_date..)
        .sum(:total_cents)
    end

    def order_count
      Order.where(created_at: @start_date..).count
    end

    def average_order_value
      avg = Order.where.not(status: :cancelled)
        .where(created_at: @start_date..)
        .average(:total_cents)
      avg&.round || 0
    end

    def customer_count
      User.customer.where(created_at: @start_date..).count
    end

    def top_products
      OrderItem.joins(:order, variant: :product)
        .where(orders: { created_at: @start_date.. })
        .where.not(orders: { status: :cancelled })
        .group("products.id", "products.name")
        .select("products.id, products.name, SUM(order_items.quantity) as total_sold, SUM(order_items.total_cents) as total_revenue")
        .order("total_sold DESC")
        .limit(5)
    end

    def recent_orders
      Order.recent.includes(:user).limit(10)
    end

    def revenue_by_day
      Order.where.not(status: :cancelled)
        .where(created_at: @start_date..)
        .group("DATE(created_at)")
        .sum(:total_cents)
        .sort_by(&:first)
    end

    def orders_by_status
      Order.group(:status).count
    end

    def low_stock_items
      StockItem.low_stock.includes(variant: :product).limit(10)
    end
  end
end
