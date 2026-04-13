class CreateDigitalDownloads < ActiveRecord::Migration[8.0]
  def change
    create_table :digital_downloads do |t|
      t.references :order_item, null: false, foreign_key: true
      t.string :access_token, null: false
      t.integer :download_count, default: 0, null: false
      t.datetime :last_downloaded_at
      t.datetime :expires_at

      t.timestamps
    end

    add_index :digital_downloads, :access_token, unique: true
  end
end
