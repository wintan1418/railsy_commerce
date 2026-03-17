class CreateStoreConfigs < ActiveRecord::Migration[8.0]
  def change
    create_table :store_configs do |t|
      t.string :key, null: false
      t.text :value
      t.timestamps
    end
    add_index :store_configs, :key, unique: true
  end
end
