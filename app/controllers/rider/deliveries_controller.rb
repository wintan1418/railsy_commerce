module Rider
  class DeliveriesController < BaseController
    before_action :set_delivery, only: %i[show accept pick_up in_transit complete]

    def index
      @filter = params[:filter] || "available"
      @deliveries = case @filter
      when "available"
        Delivery.available.includes(order: :user).recent
      when "active"
        Delivery.for_rider(current_user).active.includes(order: :user).recent
      when "completed"
        Delivery.for_rider(current_user).completed.includes(order: :user).recent
      else
        Delivery.for_rider(current_user).recent.includes(order: :user)
      end
    end

    def show
      @order = @delivery.order
      @tracking_updates = @order.tracking_updates.chronological
    end

    def accept
      @delivery.accept!(current_user)
      redirect_to rider_delivery_path(@delivery), notice: "Delivery accepted! Head to the pickup location."
    end

    def pick_up
      @delivery.pick_up!(location: params[:location])
      redirect_to rider_delivery_path(@delivery), notice: "Package picked up. Head to the delivery address."
    end

    def in_transit
      @delivery.mark_in_transit!(location: params[:location])
      redirect_to rider_delivery_path(@delivery), notice: "Status updated. Keep going!"
    end

    def complete
      @delivery.complete!(location: params[:location])
      redirect_to rider_deliveries_path(filter: "completed"), notice: "Delivery completed! Great job."
    end

    private

    def set_delivery
      @delivery = Delivery.find(params[:id])
    end
  end
end
