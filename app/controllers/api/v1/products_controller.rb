module Api
  module V1
    class ProductsController < BaseController
      skip_before_action :authenticate_api_user!

      def index
        products = Product.active.includes(:category, variants: :stock_items).ordered

        if params[:search].present?
          products = products.search(params[:search])
        end

        if params[:category_id].present?
          products = products.by_category(params[:category_id])
        end

        page = (params[:page] || 1).to_i
        per_page = [ (params[:per_page] || 20).to_i, 100 ].min
        total = products.count
        products = products.offset((page - 1) * per_page).limit(per_page)

        render json: {
          products: products.map { |p| serialize_product(p) },
          meta: { page: page, per_page: per_page, total: total }
        }
      end

      def show
        product = Product.active.friendly.find(params[:id])
        variants = product.variants.includes(:option_values, :stock_items).ordered

        render json: {
          product: serialize_product(product).merge(
            variants: variants.map { |v| serialize_variant(v) }
          )
        }
      rescue ActiveRecord::RecordNotFound
        render_not_found
      end

      private

      def serialize_product(product)
        master = product.master_variant
        {
          id: product.id,
          name: product.name,
          slug: product.slug,
          description: product.description,
          status: product.status,
          category: product.category&.name,
          category_id: product.category_id,
          price_cents: master&.price_cents,
          price: master&.price&.format,
          compare_at_price_cents: master&.compare_at_price_cents,
          in_stock: product.in_stock?,
          created_at: product.created_at
        }
      end

      def serialize_variant(variant)
        {
          id: variant.id,
          sku: variant.sku,
          price_cents: variant.price_cents,
          price: variant.price.format,
          is_master: variant.is_master?,
          in_stock: variant.in_stock?,
          options: variant.option_values.map { |ov| { name: ov.option_type.name, value: ov.presentation } }
        }
      end
    end
  end
end
