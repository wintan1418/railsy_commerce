class CreateDeliveries < ActiveRecord::Migration[8.0]
  def change
    create_table :deliveries do |t|
      t.references :order, null: false, foreign_key: true
      t.references :rider, foreign_key: { to_table: :users }
      t.references :assigned_by, foreign_key: { to_table: :users }
      t.string :status, null: false, default: "pending"
      t.string :pickup_address
      t.string :delivery_address
      t.string :rider_phone
      t.datetime :accepted_at
      t.datetime :picked_up_at
      t.datetime :delivered_at
      t.text :rider_notes
      t.integer :delivery_fee_cents, default: 0
      t.string :current_location
      t.timestamps
    end
    add_index :deliveries, :status
    add_index :deliveries, [:rider_id, :status]
  end
end
