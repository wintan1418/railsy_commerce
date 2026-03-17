class ExpireAbandonedCartsJob < ApplicationJob
  queue_as :default

  def perform
    abandoned_carts = Cart.where(completed_at: nil).where(updated_at: ..24.hours.ago)
    count = abandoned_carts.count

    abandoned_carts.find_each do |cart|
      cart.cart_items.includes(:variant).each do |item|
        Inventory::ReleaseStockService.call(
          variant: item.variant,
          quantity: item.quantity
        )
      end

      cart.destroy!
    end

    Rails.logger.info "[ExpireAbandonedCartsJob] Expired #{count} abandoned cart(s)"
  end
end
