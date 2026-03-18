module Account
  class ReturnsController < BaseController
    before_action :set_order, only: [:new, :create]

    def new
      @return_request = @order.return_requests.build
      @order_items = @order.order_items.includes(variant: :product)
    end

    def create
      @return_request = @order.return_requests.build(return_params)
      @return_request.user = current_user

      if @return_request.save
        redirect_to account_return_path(@return_request), notice: "Return request submitted."
      else
        @order_items = @order.order_items.includes(variant: :product)
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @return_request = current_user.return_requests.find(params[:id])
      @return_items = @return_request.return_items.includes(order_item: { variant: :product })
    end

    private

    def set_order
      @order = current_user.orders.find(params[:order_id])
    end

    def return_params
      params.require(:return_request).permit(
        :reason, :notes,
        return_items_attributes: [:order_item_id, :quantity, :reason]
      )
    end
  end
end
