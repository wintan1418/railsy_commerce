class CreateThemeSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :theme_settings do |t|
      t.string :key, null: false
      t.text :value
      t.string :setting_type, null: false, default: "text"
      t.string :group, null: false, default: "general"
      t.string :label, null: false
      t.text :description
      t.integer :position, default: 0

      t.timestamps
    end

    add_index :theme_settings, :key, unique: true
    add_index :theme_settings, :group
    add_index :theme_settings, :position
  end
end
