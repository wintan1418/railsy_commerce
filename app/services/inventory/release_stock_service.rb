module Inventory
  class ReleaseStockService < ApplicationService
    def initialize(variant:, quantity:, stock_location: nil)
      @variant = variant
      @quantity = quantity
      @stock_location = stock_location || StockLocation.default_location
    end

    def call
      stock_item = @variant.stock_items.find_by(stock_location: @stock_location)

      return failure("No stock item found for this variant") unless stock_item

      stock_item.with_lock do
        release_qty = [ @quantity, stock_item.reserved_quantity ].min
        stock_item.update!(
          available_quantity: stock_item.available_quantity + release_qty,
          reserved_quantity: stock_item.reserved_quantity - release_qty
        )
      end

      success(stock_item: stock_item)
    end
  end
end
