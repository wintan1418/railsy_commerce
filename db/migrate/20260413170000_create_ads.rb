class CreateAds < ActiveRecord::Migration[8.0]
  def change
    create_table :ads do |t|
      t.string :title, null: false
      t.string :subtitle
      t.string :link_url
      t.string :placement, null: false, default: "home_mid"
      t.integer :position, default: 0, null: false
      t.boolean :active, default: true, null: false
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end

    add_index :ads, [ :placement, :active, :position ]
  end
end
