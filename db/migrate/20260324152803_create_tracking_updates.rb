class CreateTrackingUpdates < ActiveRecord::Migration[8.0]
  def change
    create_table :tracking_updates do |t|
      t.references :order, null: false, foreign_key: true
      t.string :status, null: false
      t.string :location
      t.text :description, null: false
      t.datetime :estimated_delivery
      t.references :updated_by, foreign_key: { to_table: :users }
      t.timestamps
    end
    add_index :tracking_updates, [:order_id, :created_at]

    add_column :orders, :tracking_number, :string
    add_index :orders, :tracking_number
  end
end
