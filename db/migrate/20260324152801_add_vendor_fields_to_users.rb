class AddVendorFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :vendor_name, :string
    add_column :users, :vendor_description, :text
    add_column :users, :vendor_verified, :boolean, default: false
    add_column :users, :vendor_commission_rate, :decimal, precision: 5, scale: 2, default: 10.0
    add_column :users, :phone, :string
    add_reference :products, :vendor, foreign_key: { to_table: :users }
  end
end
