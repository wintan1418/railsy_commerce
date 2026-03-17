class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :number, null: false
      t.references :user, foreign_key: true
      t.string :email, null: false
      t.string :status, null: false, default: "pending"
      t.bigint :billing_address_id
      t.bigint :shipping_address_id
      t.integer :subtotal_cents, null: false, default: 0
      t.integer :shipping_total_cents, null: false, default: 0
      t.integer :tax_total_cents, null: false, default: 0
      t.integer :discount_total_cents, null: false, default: 0
      t.integer :total_cents, null: false, default: 0
      t.string :currency, null: false, default: "USD"
      t.text :notes
      t.datetime :completed_at

      t.timestamps
    end

    add_index :orders, :number, unique: true
    add_index :orders, :status
    add_foreign_key :orders, :addresses, column: :billing_address_id
    add_foreign_key :orders, :addresses, column: :shipping_address_id
  end
end
