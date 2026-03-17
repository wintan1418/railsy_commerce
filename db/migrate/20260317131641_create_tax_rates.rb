class CreateTaxRates < ActiveRecord::Migration[8.0]
  def change
    create_table :tax_rates do |t|
      t.string :name, null: false
      t.decimal :rate, null: false, precision: 8, scale: 6
      t.string :country_code, null: false
      t.string :state
      t.boolean :active, default: true
      t.timestamps
    end
    add_index :tax_rates, [:country_code, :state]
  end
end
