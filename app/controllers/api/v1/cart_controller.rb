module Api
  module V1
    class CartController < BaseController
      def show
        cart = find_or_create_cart
        items = cart.cart_items.includes(variant: :product)

        render json: {
          cart: {
            id: cart.id,
            item_count: cart.item_count,
            subtotal_cents: cart.subtotal.cents,
            items: items.map { |item| serialize_cart_item(item) }
          }
        }
      end

      def add_item
        cart = find_or_create_cart
        variant = Variant.find(params[:variant_id])
        result = Carts::AddItemService.call(
          cart: cart,
          variant: variant,
          quantity: params[:quantity] || 1
        )

        if result.success?
          render json: { message: "Item added", cart_item: serialize_cart_item(result.payload[:cart_item]) }, status: :created
        else
          render_unprocessable(result.errors)
        end
      rescue ActiveRecord::RecordNotFound
        render_not_found
      end

      def update_item
        cart = find_or_create_cart
        cart_item = cart.cart_items.find(params[:cart_item_id])

        if cart_item.update(quantity: params[:quantity].to_i)
          render json: { message: "Item updated", cart_item: serialize_cart_item(cart_item) }
        else
          render_unprocessable(cart_item.errors.full_messages)
        end
      rescue ActiveRecord::RecordNotFound
        render_not_found
      end

      def remove_item
        cart = find_or_create_cart
        cart_item = cart.cart_items.find(params[:cart_item_id])
        cart_item.destroy

        render json: { message: "Item removed" }
      rescue ActiveRecord::RecordNotFound
        render_not_found
      end

      private

      def find_or_create_cart
        current_user.carts.active.last || current_user.carts.create!
      end

      def serialize_cart_item(item)
        {
          id: item.id,
          variant_id: item.variant_id,
          product_name: item.variant.product.name,
          variant_sku: item.variant.sku,
          quantity: item.quantity,
          unit_price_cents: item.variant.price_cents,
          subtotal_cents: item.subtotal.cents
        }
      end
    end
  end
end
