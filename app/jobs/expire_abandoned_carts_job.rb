class ExpireAbandonedCartsJob < ApplicationJob
  queue_as :default

  def perform
    abandoned_carts = Cart.where(completed_at: nil).where(updated_at: ..24.hours.ago)
    count = abandoned_carts.count

    abandoned_carts.find_each do |cart|
      # Send abandoned cart email if user has email and cart has items
      if cart.user&.email_address.present? && cart.cart_items.any?
        CartMailer.abandoned(cart).deliver_later
      end

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
