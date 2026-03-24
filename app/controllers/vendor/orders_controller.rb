module Vendor
  class OrdersController < BaseController
    before_action :set_order, only: %i[show update]

    def index
      @orders = Order.joins(order_items: { variant: :product })
        .where(products: { vendor_id: current_user.id })
        .distinct.recent.includes(:user)
    end

    def show
      @order_items = @order.order_items.joins(variant: :product)
        .where(products: { vendor_id: current_user.id })
        .includes(variant: :product)
      @tracking_updates = @order.tracking_updates.chronological
    end

    def update
      description = params[:tracking_update][:description]
      status = params[:tracking_update][:status]
      location = params[:tracking_update][:location]

      @order.tracking_updates.create!(
        status: status,
        description: description,
        location: location,
        estimated_delivery: params[:tracking_update][:estimated_delivery],
        updated_by: current_user
      )

      # Update order tracking number if provided
      if params[:tracking_number].present?
        @order.update!(tracking_number: params[:tracking_number])
      end

      redirect_to vendor_order_path(@order), notice: "Tracking updated."
    end

    private

    def set_order
      @order = Order.joins(order_items: { variant: :product })
        .where(products: { vendor_id: current_user.id })
        .distinct.find(params[:id])
    end
  end
end
