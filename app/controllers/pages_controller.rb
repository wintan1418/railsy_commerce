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
  end

  def show
    @page = Page.published.friendly.find(params[:slug])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def hire
  end
end
