module Storefront
  class ProductsController < ApplicationController
    include CartManagement
    allow_unauthenticated_access

    def index
      result = Products::FilterService.call(params: params)
      @products = result.payload[:products]
      @categories = Category.active.roots.ordered.includes(:children)
    end

    def show
      @product = Product.friendly.find(params[:id])
      @variants = @product.variants.includes(:option_values, :stock_items).ordered
      @master_variant = @product.master_variant
      @reviews = @product.reviews.approved.recent.includes(:user).limit(10)
      @related_products = Product.active
        .where(category_id: @product.category_id)
        .where.not(id: @product.id)
        .includes(variants: :stock_items)
        .limit(4)
    end
  end
end
