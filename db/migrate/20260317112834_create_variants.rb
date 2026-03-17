class CreateVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :sku
      t.integer :price_cents, null: false, default: 0
      t.string :price_currency, null: false, default: "USD"
      t.integer :compare_at_price_cents
      t.integer :cost_price_cents
      t.decimal :weight, precision: 10, scale: 2
      t.decimal :width, precision: 10, scale: 2
      t.decimal :height, precision: 10, scale: 2
      t.decimal :depth, precision: 10, scale: 2
      t.boolean :is_master, default: false
      t.integer :position, default: 0

      t.timestamps
    end

    add_index :variants, :sku, unique: true, where: "sku IS NOT NULL"
  end
end
