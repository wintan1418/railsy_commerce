module Admin
  class ShippingMethodsController < BaseController
    before_action :set_shipping_method, only: %i[edit update destroy]

    def index
      @shipping_methods = ShippingMethod.order(:name)
    end

    def new
      @shipping_method = ShippingMethod.new
    end

    def create
      @shipping_method = ShippingMethod.new(shipping_method_params)
      if @shipping_method.save
        redirect_to admin_shipping_methods_path, notice: "Shipping method created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @shipping_method.update(shipping_method_params)
        redirect_to admin_shipping_methods_path, notice: "Shipping method updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @shipping_method.destroy
      redirect_to admin_shipping_methods_path, notice: "Shipping method deleted."
    end

    private

    def set_shipping_method
      @shipping_method = ShippingMethod.find(params[:id])
    end

    def shipping_method_params
      params.require(:shipping_method).permit(:name, :description, :price_cents, :min_delivery_days, :max_delivery_days, :active)
    end
  end
end
