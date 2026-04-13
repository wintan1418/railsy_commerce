class AddReferralToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :referral_code, :string
    add_reference :users, :referred_by, foreign_key: { to_table: :users }
    add_index :users, :referral_code, unique: true
  end
end
