class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.references :user, foreign_key: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :address_line_1, null: false
      t.string :address_line_2
      t.string :city, null: false
      t.string :state
      t.string :postal_code, null: false
      t.string :country_code, null: false, default: "US"
      t.string :phone

      t.timestamps
    end
  end
end
