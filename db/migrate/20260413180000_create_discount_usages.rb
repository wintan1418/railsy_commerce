class CreateDiscountUsages < ActiveRecord::Migration[8.0]
  def change
    create_table :discount_usages do |t|
      t.references :discount, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.datetime :used_at, null: false

      t.timestamps
    end

    add_index :discount_usages, [ :discount_id, :user_id ]
  end
end
