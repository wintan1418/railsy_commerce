module Storefront
  class CompareController < ApplicationController
    include CartManagement
    allow_unauthenticated_access

    def show
      ids = params[:ids].to_s.split(",").map(&:to_i).first(4)
      @products = Product.active.where(id: ids).includes(:category, variants: :stock_items)

      if @products.empty?
        redirect_to products_path, alert: "Please select products to compare."
      end
    end
  end
end
