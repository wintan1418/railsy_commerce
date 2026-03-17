class AddLowStockThresholdToStockItems < ActiveRecord::Migration[8.0]
  def change
    add_column :stock_items, :low_stock_threshold, :integer, default: 5
  end
end
