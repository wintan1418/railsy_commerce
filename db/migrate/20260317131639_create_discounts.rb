class CreateDiscounts < ActiveRecord::Migration[8.0]
  def change
    create_table :discounts do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.string :discount_type, null: false
      t.decimal :amount, null: false, precision: 10, scale: 2
      t.integer :minimum_order_cents
      t.integer :usage_limit
      t.integer :usage_count, null: false, default: 0
      t.integer :per_user_limit, default: 1
      t.datetime :starts_at
      t.datetime :expires_at
      t.boolean :active, default: true
      t.timestamps
    end
    add_index :discounts, :code, unique: true
  end
end
