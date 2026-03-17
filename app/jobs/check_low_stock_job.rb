class CheckLowStockJob < ApplicationJob
  queue_as :default

  def perform
    low_stock = StockItem.low_stock.includes(variant: :product)

    return if low_stock.empty?

    low_stock.each do |item|
      Rails.logger.info "[LOW STOCK] #{item.variant.product.name} (#{item.variant.sku}): #{item.available_quantity} remaining"
    end
  end
end
