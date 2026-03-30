class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating, null: false
      t.string :title
      t.text :body
      t.string :status, null: false, default: "pending"
      t.timestamps
    end
    add_index :reviews, [ :product_id, :user_id ], unique: true
    add_index :reviews, :status
  end
end
