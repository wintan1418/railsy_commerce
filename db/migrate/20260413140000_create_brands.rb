class CreateBrands < ActiveRecord::Migration[8.0]
  def change
    create_table :brands do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :website
      t.boolean :active, default: true, null: false
      t.boolean :featured, default: false, null: false
      t.integer :position, default: 0, null: false

      t.timestamps
    end

    add_index :brands, :slug, unique: true
    add_index :brands, [ :active, :featured, :position ]

    add_reference :products, :brand, foreign_key: true, index: true
  end
end
