class PagesController < ApplicationController
  include CartManagement
  allow_unauthenticated_access

  def home
    @featured_products = Product.active.includes(:category, variants: :stock_items).ordered.limit(12)
    @categories = Category.active.roots.ordered.includes(:children)
    @category_counts = @categories.index_with { |cat|
      child_ids = cat.children.pluck(:id)
      Product.active.where(category_id: [ cat.id ] + child_ids).count
    }
  end
end
