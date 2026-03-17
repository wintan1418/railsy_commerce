module Inventory
  class ReserveStockService < ApplicationService
    def initialize(variant:, quantity:, stock_location: nil)
      @variant = variant
      @quantity = quantity
      @stock_location = stock_location || StockLocation.default_location
    end

    def call
      stock_item = @variant.stock_items.find_by(stock_location: @stock_location)

      return failure("No stock item found for this variant") unless stock_item
      return failure("Insufficient stock") unless stock_item.can_reserve?(@quantity)

      reserved = stock_item.with_lock do
        actual_reserve = [ @quantity, stock_item.available_quantity ].min
        stock_item.update!(
          available_quantity: stock_item.available_quantity - actual_reserve,
          reserved_quantity: stock_item.reserved_quantity + @quantity
        )
        true
      end

      reserved ? success(stock_item: stock_item) : failure("Could not reserve stock")
    end
  end
end
