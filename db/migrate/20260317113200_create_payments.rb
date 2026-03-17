class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.integer :amount_cents, null: false
      t.string :currency, null: false, default: "USD"
      t.string :status, null: false, default: "pending"
      t.string :payment_method, null: false
      t.string :stripe_payment_intent_id
      t.string :stripe_charge_id
      t.jsonb :response_data

      t.timestamps
    end

    add_index :payments, :stripe_payment_intent_id
  end
end
