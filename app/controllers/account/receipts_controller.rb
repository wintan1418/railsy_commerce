module Account
  class ReceiptsController < BaseController
    def show
      @order = current_user.orders.find(params[:order_id])
      @order_items = @order.order_items.includes(variant: { product: { images_attachments: :blob } })
    end
  end
end
