class CreateReturns < ActiveRecord::Migration[8.0]
  def change
    create_table :returns do |t|
      t.references :order, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.string :status, null: false, default: "requested"
      t.text :reason, null: false
      t.text :notes
      t.integer :refund_amount_cents
      t.string :currency, default: "USD"

      t.timestamps
    end

    add_index :returns, :status
  end
end
