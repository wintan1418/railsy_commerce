module Carts
  class MergeCartsService < ApplicationService
    def initialize(guest_cart:, user_cart:)
      @guest_cart = guest_cart
      @user_cart = user_cart
    end

    def call
      return success(cart: @user_cart) if @guest_cart.blank? || @guest_cart == @user_cart

      @guest_cart.cart_items.each do |guest_item|
        existing = @user_cart.cart_items.find_by(variant_id: guest_item.variant_id)
        if existing
          existing.update!(quantity: existing.quantity + guest_item.quantity)
        else
          guest_item.update!(cart: @user_cart)
        end
      end

      @guest_cart.destroy
      success(cart: @user_cart)
    end
  end
end
