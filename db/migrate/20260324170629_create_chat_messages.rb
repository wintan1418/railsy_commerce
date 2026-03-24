class CreateChatMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_messages do |t|
      t.references :user, foreign_key: true
      t.string :guest_token
      t.string :sender_type, null: false, default: "customer"
      t.text :body, null: false
      t.datetime :read_at
      t.string :conversation_id, null: false

      t.timestamps
    end
    add_index :chat_messages, :conversation_id
    add_index :chat_messages, :guest_token
  end
end
