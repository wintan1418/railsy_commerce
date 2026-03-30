module Admin
  class DeliveriesController < BaseController
    def index
      @deliveries = Delivery.includes(order: :user, rider: []).recent
      @deliveries = @deliveries.where(status: params[:status]) if params[:status].present?
    end

    def create
      order = Order.find(params[:order_id])
      delivery = order.build_delivery(
        status: :pending,
        pickup_address: params[:pickup_address] || "Warehouse",
        delivery_address: order.shipping_address&.one_line,
        delivery_fee_cents: (params[:delivery_fee].to_f * 100).to_i,
        assigned_by: current_user
      )

      if params[:rider_id].present?
        rider = User.rider.find(params[:rider_id])
        delivery.rider = rider
        delivery.status = :assigned
        delivery.rider_phone = rider.phone
      end

      if delivery.save
        order.tracking_updates.create!(
          status: "processing",
          description: "Your order has been assigned for delivery.",
          updated_by: current_user
        )
        redirect_back fallback_location: admin_order_path(order), notice: "Delivery created."
      else
        redirect_back fallback_location: admin_order_path(order), alert: delivery.errors.full_messages.join(", ")
      end
    end
  end
end
