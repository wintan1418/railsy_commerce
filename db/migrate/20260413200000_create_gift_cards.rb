class CreateGiftCards < ActiveRecord::Migration[8.0]
  def change
    create_table :gift_cards do |t|
      t.string :code, null: false
      t.integer :initial_balance_cents, null: false
      t.integer :balance_cents, null: false
      t.boolean :active, default: true, null: false
      t.datetime :expires_at
      t.references :purchaser, foreign_key: { to_table: :users }
      t.string :recipient_email
      t.text :notes

      t.timestamps
    end

    add_index :gift_cards, :code, unique: true

    create_table :gift_card_transactions do |t|
      t.references :gift_card, null: false, foreign_key: true
      t.references :order, foreign_key: true
      t.integer :amount_cents, null: false
      t.string :kind, null: false  # "redeem" / "refund" / "adjust"
      t.datetime :occurred_at, null: false

      t.timestamps
    end
  end
end
