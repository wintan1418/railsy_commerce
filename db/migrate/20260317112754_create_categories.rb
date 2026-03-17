class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.bigint :parent_id
      t.integer :position, default: 0
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :categories, :slug, unique: true
    add_index :categories, :parent_id
    add_index :categories, :position
  end
end
