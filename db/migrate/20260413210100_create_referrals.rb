class CreateReferrals < ActiveRecord::Migration[8.0]
  def change
    create_table :referrals do |t|
      t.references :referrer, null: false, foreign_key: { to_table: :users }
      t.references :referred_user, null: false, foreign_key: { to_table: :users }
      t.references :triggering_order, foreign_key: { to_table: :orders }
      t.references :reward_gift_card, foreign_key: { to_table: :gift_cards }
      t.integer :reward_amount_cents, default: 0, null: false
      t.string :status, default: "pending", null: false
      t.datetime :rewarded_at

      t.timestamps
    end

    add_index :referrals, [ :referrer_id, :referred_user_id ], unique: true
  end
end
