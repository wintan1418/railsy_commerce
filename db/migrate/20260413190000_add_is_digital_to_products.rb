class AddIsDigitalToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :is_digital, :boolean, default: false, null: false
    add_index :products, :is_digital
  end
end
