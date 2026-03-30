module Rider
  class DashboardController < BaseController
    def show
      @available_deliveries = Delivery.available.includes(order: :user).recent
      @active_delivery = Delivery.for_rider(current_user).active.includes(order: [:user, :shipping_address]).first
      @completed_today = Delivery.for_rider(current_user).completed.where(delivered_at: Time.current.beginning_of_day..).count
      @total_completed = Delivery.for_rider(current_user).completed.count
      @total_earnings = Delivery.for_rider(current_user).completed.sum(:delivery_fee_cents)
    end
  end
end
