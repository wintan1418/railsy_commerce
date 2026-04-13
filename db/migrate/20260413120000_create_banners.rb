class CreateBanners < ActiveRecord::Migration[8.0]
  def change
    create_table :banners do |t|
      t.string :title, null: false
      t.string :subtitle
      t.string :eyebrow
      t.string :link_url
      t.string :link_text
      t.integer :position, default: 0, null: false
      t.boolean :active, default: true, null: false
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end

    add_index :banners, [ :active, :position ]
  end
end
