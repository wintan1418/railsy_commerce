class CreateShipments < ActiveRecord::Migration[8.0]
  def change
    create_table :shipments do |t|
      t.references :order, null: false, foreign_key: true
      t.references :shipping_method, null: false, foreign_key: true
      t.string :tracking_number
      t.string :status, null: false, default: "pending"
      t.datetime :shipped_at
      t.datetime :delivered_at

      t.timestamps
    end
  end
end
