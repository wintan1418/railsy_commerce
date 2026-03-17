module Admin
  class DiscountsController < BaseController
    before_action :set_discount, only: %i[edit update destroy]

    def index
      @discounts = Discount.order(created_at: :desc)
    end

    def new
      @discount = Discount.new
    end

    def create
      @discount = Discount.new(discount_params)
      if @discount.save
        redirect_to admin_discounts_path, notice: "Discount created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @discount.update(discount_params)
        redirect_to admin_discounts_path, notice: "Discount updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @discount.destroy
      redirect_to admin_discounts_path, notice: "Discount deleted."
    end

    private

    def set_discount
      @discount = Discount.find(params[:id])
    end

    def discount_params
      params.require(:discount).permit(:code, :name, :discount_type, :amount, :minimum_order_cents, :usage_limit, :per_user_limit, :starts_at, :expires_at, :active)
    end
  end
end
