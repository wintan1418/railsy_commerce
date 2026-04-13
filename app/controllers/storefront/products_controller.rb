module Storefront
  class ProductsController < ApplicationController
    include CartManagement
    allow_unauthenticated_access

    def index
      result = Products::FilterService.call(params: params)
      @products = result.payload[:products]
      @categories = Category.active.roots.ordered.includes(:children)
      @brand_facets = Brand.active.ordered
        .left_joins(:products)
        .where("products.status = ? OR products.id IS NULL", "active")
        .group("brands.id").select("brands.*, COUNT(products.id) AS products_count")
      @selected_brand = params[:brand].present? ? (Brand.friendly.find(params[:brand]) rescue nil) : nil
      @recently_viewed = recently_viewed_products
    end

    def show
      @product = Product.friendly.find(params[:id])
      @variants = @product.variants.includes(:option_values, :stock_items).ordered
      @master_variant = @product.master_variant
      @reviews = @product.reviews.approved.recent.includes(:user).limit(10)
      @related_products = @product.related(limit: 4)
      @recently_viewed = recently_viewed_products.reject { |p| p.id == @product.id }

      track_recently_viewed(@product.id)
    end

    private

    def track_recently_viewed(product_id)
      ids = recently_viewed_ids
      ids.delete(product_id)
      ids.unshift(product_id)
      cookies[:recently_viewed] = { value: ids.first(10).join(","), expires: 30.days.from_now }
    end

    def recently_viewed_ids
      cookies[:recently_viewed].to_s.split(",").map(&:to_i).reject(&:zero?)
    end

    def recently_viewed_products
      ids = recently_viewed_ids
      return [] if ids.empty?

      products = Product.active.where(id: ids).includes(:category, variants: :stock_items)
      # Preserve cookie order
      ids.filter_map { |id| products.find { |p| p.id == id } }.first(10)
    end
  end
end
