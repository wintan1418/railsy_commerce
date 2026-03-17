module Storefront
  class ProductsController < ApplicationController
    include CartManagement
    allow_unauthenticated_access

    def index
      @products = Product.active.includes(:category, variants: :stock_items).ordered
      @products = @products.by_category(params[:category_id]) if params[:category_id].present?
      @products = @products.search(params[:q]) if params[:q].present?
      @categories = Category.active.roots.ordered
    end

    def show
      @product = Product.friendly.find(params[:id])
      @variants = @product.variants.includes(:option_values, :stock_items).ordered
      @master_variant = @product.master_variant
    end
  end
end
