module Account
  class OrdersController < BaseController
    def index
      @orders = current_user.orders.recent.includes(:order_items)
    end

    def show
      @order = current_user.orders.find(params[:id])
      @order_items = @order.order_items.includes(variant: :product)
    end
  end
end
