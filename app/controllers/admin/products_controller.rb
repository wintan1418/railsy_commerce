module Admin
  class ProductsController < BaseController
    before_action :set_product, only: %i[show edit update destroy]

    def index
      @products = Product.includes(:category, :variants).ordered
      @products = @products.where(status: params[:status]) if params[:status].present?
    end

    def show
      @variants = @product.variants.includes(:option_values, :stock_items).ordered
    end

    def new
      @product = Product.new
      @product.variants.build(is_master: true)
    end

    def create
      @product = Product.new(product_params)

      if @product.save
        redirect_to admin_product_path(@product), notice: "Product created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @product.update(product_params)
        redirect_to admin_product_path(@product), notice: "Product updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_products_path, notice: "Product deleted."
    end

    private

    def set_product
      @product = Product.friendly.find(params[:id])
    end

    def product_params
      params.require(:product).permit(
        :name, :description, :status, :category_id,
        :meta_title, :meta_description, images: [],
        variants_attributes: [
          :id, :sku, :price_cents, :compare_at_price_cents,
          :cost_price_cents, :weight, :is_master, :_destroy,
          images: []
        ]
      )
    end
  end
end
