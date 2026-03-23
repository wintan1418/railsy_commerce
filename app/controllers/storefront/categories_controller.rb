module Storefront
  class CategoriesController < ApplicationController
    include CartManagement
    allow_unauthenticated_access

    def show
      @category = Category.friendly.find(params[:slug])
      @subcategories = @category.children.active.ordered

      # Include products from subcategories too
      category_ids = [ @category.id ] + @subcategories.pluck(:id)
      @products = Product.active.where(category_id: category_ids).includes(:category, variants: :stock_items).ordered
    end
  end
end
