module Storefront
  class TrackingController < ApplicationController
    include CartManagement
    allow_unauthenticated_access

    def show
      @order = Order.find_by(tracking_number: params[:tracking_number]) ||
               Order.find_by(number: params[:tracking_number])

      if @order.nil?
        flash.now[:alert] = "Order not found. Please check your tracking number."
        render :search
      else
        @tracking_updates = @order.tracking_updates.chronological
        @current_status = @tracking_updates.last&.status || "order_placed"
      end
    end

    def search
    end
  end
end
