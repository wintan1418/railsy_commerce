class CreateFlashSales < ActiveRecord::Migration[8.0]
  def change
    create_table :flash_sales do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.integer :discount_percentage, default: 0, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :flash_sales, :slug, unique: true
    add_index :flash_sales, [ :active, :starts_at, :ends_at ]

    create_table :flash_sale_products do |t|
      t.references :flash_sale, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :sale_price_cents
      t.integer :stock_limit
      t.integer :sold_count, default: 0, null: false

      t.timestamps
    end

    add_index :flash_sale_products, [ :flash_sale_id, :product_id ], unique: true
  end
end
