module Admin
  class InventoryController < BaseController
    def index
      @stock_items = StockItem.includes(variant: :product).order(:id)
      if params[:search].present?
        search = "%#{params[:search]}%"
        @stock_items = @stock_items.joins(variant: :product).where(
          "products.name ILIKE :q OR variants.sku ILIKE :q", q: search
        )
      end
      if params[:low_stock] == "1"
        @stock_items = @stock_items.low_stock
      end
    end

    def update
      @stock_item = StockItem.find(params[:id])
      if @stock_item.update(stock_item_params)
        redirect_to admin_inventory_index_path, notice: "Stock updated."
      else
        redirect_to admin_inventory_index_path, alert: "Failed to update stock."
      end
    end

    private

    def stock_item_params
      params.require(:stock_item).permit(:available_quantity, :low_stock_threshold)
    end
  end
end
