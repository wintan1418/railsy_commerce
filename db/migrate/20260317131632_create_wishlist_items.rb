class CreateWishlistItems < ActiveRecord::Migration[8.0]
  def change
    create_table :wishlist_items do |t|
      t.references :wishlist, null: false, foreign_key: true
      t.references :variant, null: false, foreign_key: true
      t.timestamps
    end
    add_index :wishlist_items, [:wishlist_id, :variant_id], unique: true
  end
end
