module Admin
  class ReturnsController < BaseController
    before_action :set_return_request, only: [ :show, :update ]

    def index
      @return_requests = ReturnRequest.recent.includes(:order, :user)
      @return_requests = @return_requests.where(status: params[:status]) if params[:status].present?
    end

    def show
      @return_items = @return_request.return_items.includes(order_item: { variant: :product })
    end

    def update
      if @return_request.update(return_params)
        if @return_request.user
          Notification.create!(
            user: @return_request.user,
            title: "Return request #{@return_request.status}",
            body: "Your return for order #{@return_request.order.number} has been #{@return_request.status}.",
            notification_type: "order",
            url: "/account/returns/#{@return_request.id}"
          )
        end
        redirect_to admin_return_path(@return_request), notice: "Return request updated."
      else
        @return_items = @return_request.return_items.includes(order_item: { variant: :product })
        render :show, status: :unprocessable_entity
      end
    end

    private

    def set_return_request
      @return_request = ReturnRequest.find(params[:id])
    end

    def return_params
      params.require(:return_request).permit(:status, :notes, :refund_amount_cents)
    end
  end
end
