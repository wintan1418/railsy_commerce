module Admin
  class FlashSalesController < BaseController
    before_action :set_flash_sale, only: [ :edit, :update, :destroy, :toggle ]
    before_action :load_products, only: [ :new, :create, :edit, :update ]

    def index
      @flash_sales = FlashSale.ordered.includes(:products)
    end

    def new
      @flash_sale = FlashSale.new(
        active: true,
        starts_at: 1.hour.from_now.change(min: 0),
        ends_at: 1.day.from_now.change(min: 0),
        discount_percentage: 20
      )
    end

    def create
      @flash_sale = FlashSale.new(flash_sale_params.except(:product_ids))

      if @flash_sale.save
        sync_products(@flash_sale)
        redirect_to admin_flash_sales_path, notice: "Flash sale created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @flash_sale.update(flash_sale_params.except(:product_ids))
        sync_products(@flash_sale)
        redirect_to admin_flash_sales_path, notice: "Flash sale updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @flash_sale.destroy
      redirect_to admin_flash_sales_path, notice: "Flash sale deleted."
    end

    def toggle
      @flash_sale.update(active: !@flash_sale.active?)
      redirect_to admin_flash_sales_path,
        notice: "Flash sale #{@flash_sale.active? ? 'enabled' : 'disabled'}."
    end

    private

    def set_flash_sale
      @flash_sale = FlashSale.friendly.find(params[:id])
    end

    def load_products
      @products = Product.active.ordered
    end

    def flash_sale_params
      params.require(:flash_sale).permit(
        :name, :description, :starts_at, :ends_at,
        :discount_percentage, :active, product_ids: []
      )
    end

    def sync_products(flash_sale)
      ids = Array(params.dig(:flash_sale, :product_ids)).reject(&:blank?).map(&:to_i)
      flash_sale.product_ids = ids
    end
  end
end
