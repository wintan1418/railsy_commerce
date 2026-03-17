class CreateStockItems < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_items do |t|
      t.references :stock_location, null: false, foreign_key: true
      t.references :variant, null: false, foreign_key: true
      t.integer :available_quantity, null: false, default: 0
      t.integer :reserved_quantity, null: false, default: 0
      t.boolean :backorderable, default: false

      t.timestamps
    end

    add_index :stock_items, [ :stock_location_id, :variant_id ], unique: true
  end
end
