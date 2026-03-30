class PagesController < ApplicationController
  include CartManagement
  allow_unauthenticated_access

  def home
    @featured_products = Product.active.includes(:category, variants: :stock_items).ordered.limit(16)
    @categories = Category.active.roots.ordered.includes(:children)
    @category_counts = @categories.index_with { |cat|
      child_ids = cat.children.pluck(:id)
      Product.active.where(category_id: [ cat.id ] + child_ids).count
    }
    @popular_products = Product.active.includes(:category, variants: :stock_items).order("RANDOM()").limit(8)
    @sale_products = Product.active.joins(:variants).where(variants: { is_master: true }).where.not(variants: { compare_at_price_cents: nil }).includes(:category, variants: :stock_items).distinct.limit(8)

    # Recently viewed from cookie
    recently_viewed_ids = cookies[:recently_viewed].to_s.split(",").map(&:to_i).reject(&:zero?)
    if recently_viewed_ids.any?
      products = Product.active.where(id: recently_viewed_ids).includes(:category, variants: :stock_items)
      @recently_viewed = recently_viewed_ids.filter_map { |id| products.find { |p| p.id == id } }.first(4)
    else
      @recently_viewed = []
    end
  end

  def show
    @page = Page.published.friendly.find(params[:slug])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def hire
  end
end
