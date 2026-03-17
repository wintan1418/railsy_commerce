class CreateOptionValueVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :option_value_variants do |t|
      t.references :variant, null: false, foreign_key: true
      t.references :option_value, null: false, foreign_key: true

      t.timestamps
    end

    add_index :option_value_variants, [ :variant_id, :option_value_id ], unique: true
  end
end
