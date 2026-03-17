class PagesController < ApplicationController
  include CartManagement
  allow_unauthenticated_access

  def home
    @featured_products = Product.active.includes(variants: :stock_items).ordered.limit(8)
    @categories = Category.active.roots.ordered
  end
end
