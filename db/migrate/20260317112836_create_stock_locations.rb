class CreateStockLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :stock_locations do |t|
      t.string :name, null: false
      t.boolean :active, default: true
      t.boolean :default, default: false

      t.timestamps
    end
  end
end
