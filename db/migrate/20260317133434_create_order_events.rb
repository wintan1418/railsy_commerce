class CreateOrderEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :order_events do |t|
      t.references :order, null: false, foreign_key: true
      t.string :event_type, null: false
      t.jsonb :data, default: {}
      t.references :user, foreign_key: true
      t.datetime :created_at, null: false
    end
    add_index :order_events, :event_type
  end
end
