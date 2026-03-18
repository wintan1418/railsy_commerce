class CreatePromotions < ActiveRecord::Migration[8.0]
  def change
    create_table :promotions do |t|
      t.string :name, null: false
      t.string :promotion_type, null: false
      t.jsonb :conditions, default: {}
      t.boolean :active, default: true
      t.datetime :starts_at
      t.datetime :expires_at
      t.boolean :auto_apply, default: false

      t.timestamps
    end

    add_index :promotions, :active
    add_index :promotions, :promotion_type
  end
end
