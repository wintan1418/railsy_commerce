class CreateReturnItems < ActiveRecord::Migration[8.0]
  def change
    create_table :return_items do |t|
      t.references :return, null: false, foreign_key: { to_table: :returns }
      t.references :order_item, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.string :reason

      t.timestamps
    end
  end
end
