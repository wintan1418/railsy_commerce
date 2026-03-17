class AddReviewsCountToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :reviews_count, :integer, default: 0, null: false
    # Backfill
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE products SET reviews_count = (
            SELECT COUNT(*) FROM reviews
            WHERE reviews.product_id = products.id AND reviews.status = 'approved'
          )
        SQL
      end
    end
  end
end
