module Api
  module V1
    class OrdersController < BaseController
      def index
        orders = current_user.orders.recent.includes(:order_items)

        render json: {
          orders: orders.map { |o| serialize_order(o) }
        }
      end

      def show
        order = current_user.orders.find(params[:id])
        items = order.order_items.includes(variant: :product)

        render json: {
          order: serialize_order(order).merge(
            items: items.map { |item| serialize_order_item(item) }
          )
        }
      rescue ActiveRecord::RecordNotFound
        render_not_found
      end

      private

      def serialize_order(order)
        {
          id: order.id,
          number: order.number,
          status: order.status,
          email: order.email,
          subtotal_cents: order.subtotal_cents,
          shipping_total_cents: order.shipping_total_cents,
          tax_total_cents: order.tax_total_cents,
          discount_total_cents: order.discount_total_cents,
          total_cents: order.total_cents,
          currency: order.currency,
          created_at: order.created_at
        }
      end

      def serialize_order_item(item)
        {
          id: item.id,
          product_name: item.variant.product.name,
          variant_sku: item.variant.sku,
          quantity: item.quantity,
          unit_price_cents: item.unit_price_cents,
          total_cents: item.total_cents
        }
      end
    end
  end
end
