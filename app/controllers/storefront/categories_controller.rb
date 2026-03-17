module Storefront
  class CategoriesController < ApplicationController
    include CartManagement
    allow_unauthenticated_access

    def show
      @category = Category.friendly.find(params[:slug])
      @products = @category.products.active.includes(variants: :stock_items).ordered
      @subcategories = @category.children.active.ordered
    end
  end
end
