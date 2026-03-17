class CreateShippingMethods < ActiveRecord::Migration[8.0]
  def change
    create_table :shipping_methods do |t|
      t.string :name, null: false
      t.string :description
      t.integer :price_cents, null: false, default: 0
      t.string :currency, null: false, default: "USD"
      t.integer :min_delivery_days
      t.integer :max_delivery_days
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
