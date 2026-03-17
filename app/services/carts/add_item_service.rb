module Carts
  class AddItemService < ApplicationService
    def initialize(cart:, variant:, quantity: 1)
      @cart = cart
      @variant = variant
      @quantity = quantity.to_i
    end

    def call
      return failure("Quantity must be positive") if @quantity <= 0
      return failure("Product is not available") unless @variant.product.active?
      return failure("Item is out of stock") unless @variant.in_stock?

      cart_item = @cart.cart_items.find_by(variant: @variant)

      if cart_item
        cart_item.quantity += @quantity
      else
        cart_item = @cart.cart_items.build(variant: @variant, quantity: @quantity)
      end

      if cart_item.save
        success(cart_item: cart_item, cart: @cart)
      else
        failure(cart_item.errors.full_messages)
      end
    end
  end
end
