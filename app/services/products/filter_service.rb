module Products
  class FilterService < ApplicationService
    def initialize(params:)
      @params = params
    end

    def call
      products = Product.active.includes(:category, variants: :stock_items)

      products = filter_by_category(products)
      products = filter_by_search(products)
      products = filter_by_price(products)
      products = filter_by_sale(products)
      products = apply_sort(products)

      success(products: products)
    end

    private

    def filter_by_category(products)
      return products unless @params[:category_id].present?

      category = Category.find_by(id: @params[:category_id])
      return products unless category

      child_ids = category.children.pluck(:id)
      products.where(category_id: [ category.id ] + child_ids)
    end

    def filter_by_search(products)
      return products unless @params[:q].present?
      products.search(@params[:q])
    end

    def filter_by_price(products)
      if @params[:min_price].present?
        min_cents = (@params[:min_price].to_f * 100).to_i
        products = products.joins(:variants).where(variants: { is_master: true }).where("variants.price_cents >= ?", min_cents)
      end
      if @params[:max_price].present?
        max_cents = (@params[:max_price].to_f * 100).to_i
        products = products.joins(:variants).where(variants: { is_master: true }).where("variants.price_cents <= ?", max_cents)
      end
      products
    end

    def filter_by_sale(products)
      return products unless @params[:on_sale] == "true" || @params[:on_sale] == true
      products.joins(:variants).where(variants: { is_master: true }).where.not(variants: { compare_at_price_cents: nil })
    end

    def apply_sort(products)
      case @params[:sort]
      when "price_asc"
        products.left_joins(:variants).where(variants: { is_master: true }).order("variants.price_cents ASC")
      when "price_desc"
        products.left_joins(:variants).where(variants: { is_master: true }).order("variants.price_cents DESC")
      when "name_asc"
        products.order(name: :asc)
      when "name_desc"
        products.order(name: :desc)
      when "newest"
        products.order(created_at: :desc)
      else
        products.order(created_at: :desc)
      end
    end
  end
end
