module Admin
  class CustomersController < BaseController
    def index
      @customers = User.customer.order(created_at: :desc)
      if params[:search].present?
        search = "%#{params[:search]}%"
        @customers = @customers.where(
          "first_name ILIKE :q OR last_name ILIKE :q OR email_address ILIKE :q", q: search
        )
      end
    end

    def show
      @customer = User.customer.find(params[:id])
      @orders = @customer.orders.recent
      @addresses = @customer.addresses
      @total_spent = @orders.sum(:total_cents)
      @order_count = @orders.count
    end
  end
end
