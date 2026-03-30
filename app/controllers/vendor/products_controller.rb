module Vendor
  class ProductsController < BaseController
    before_action :set_product, only: %i[edit update destroy]

    def index
      @products = current_user.vendor_products.includes(:category, variants: :stock_items).ordered
    end

    def new
      @product = current_user.vendor_products.build
      @product.variants.build(is_master: true)
    end

    def create
      @product = current_user.vendor_products.build(product_params)
      if @product.save
        redirect_to vendor_products_path, notice: "Product created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @product.update(product_params)
        redirect_to vendor_products_path, notice: "Product updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
      redirect_to vendor_products_path, notice: "Product deleted."
    end

    private

    def set_product
      @product = current_user.vendor_products.friendly.find(params[:id])
    end

    def product_params
      params.require(:product).permit(
        :name, :description, :status, :category_id, :meta_title, :meta_description, images: [],
        variants_attributes: [ :id, :sku, :price_cents, :compare_at_price_cents, :is_master, :_destroy ]
      )
    end
  end
end
