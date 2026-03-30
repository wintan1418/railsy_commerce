module Admin
  class OrdersController < BaseController
    before_action :set_order, only: %i[show update]

    def index
      @orders = Order.recent.includes(:user)
      @orders = @orders.where(status: params[:status]) if params[:status].present?

      respond_to do |format|
        format.html
        format.csv { send_data generate_csv(@orders), filename: "orders-#{Date.current}.csv" }
      end
    end

    def show
      @order_items = @order.order_items.includes(variant: :product)
      @payments = @order.payments
      @shipments = @order.shipments.includes(:shipping_method)
      @events = @order.order_events.recent.includes(:user)
    end

    def update
      old_status = @order.status
      if @order.update(order_params)
        if old_status != @order.status
          OrderEvent.log(
            order: @order,
            event_type: "status_change",
            data: { from: old_status, to: @order.status },
            user: current_user
          )

          # Create notification for the customer
          if @order.user
            Notification.create!(
              user: @order.user,
              title: "Order #{@order.number} #{@order.status}",
              body: "Your order status has been updated to #{@order.status}.",
              notification_type: "order",
              url: "/account/orders/#{@order.id}"
            )
          end
        end
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

    def generate_csv(orders)
      require "csv"
      CSV.generate(headers: true) do |csv|
        csv << %w[Number Email Status Subtotal Shipping Tax Discount Total Date]
        orders.each do |o|
          csv << [
            o.number, o.email, o.status,
            o.subtotal.format, o.shipping_total.format,
            o.tax_total.format, o.discount_total.format,
            o.total.format, o.created_at.strftime("%Y-%m-%d")
          ]
        end
      end
    end
  end
end
