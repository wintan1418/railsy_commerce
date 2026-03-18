class CreateProductRelations < ActiveRecord::Migration[8.0]
  def change
    create_table :product_relations do |t|
      t.references :product, null: false, foreign_key: true
      t.references :related_product, null: false, foreign_key: { to_table: :products }
      t.string :relation_type, null: false, default: "related"
      t.integer :position, default: 0

      t.timestamps
    end

    add_index :product_relations, [:product_id, :related_product_id], unique: true
  end
end
