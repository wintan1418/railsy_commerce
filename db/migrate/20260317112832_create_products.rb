class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description
      t.string :status, null: false, default: "draft"
      t.references :category, foreign_key: true
      t.string :meta_title
      t.text :meta_description

      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, :status
  end
end
