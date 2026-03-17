module Admin
  class OrdersController < BaseController
    before_action :set_order, only: %i[show update]

    def index
      @orders = Order.recent.includes(:user)
      @orders = @orders.where(status: params[:status]) if params[:status].present?
    end

    def show
      @order_items = @order.order_items.includes(variant: :product)
      @payments = @order.payments
      @shipments = @order.shipments.includes(:shipping_method)
    end

    def update
      if @order.update(order_params)
        redirect_to admin_order_path(@order), notice: "Order updated."
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:status, :notes)
    end
  end
end
