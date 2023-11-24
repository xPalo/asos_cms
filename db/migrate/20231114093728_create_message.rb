class CreateMessage < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :sender, null: false, index: { name: 'index_sender_id_on_user' }, foreign_key: { on_delete: :cascade }
      t.references :receiver, null: false, index: { name: 'index_receiver_id_on_user' }, foreign_key: { on_delete: :cascade }
      t.string :subject, null: false
      t.string :content, null: false
      t.boolean :is_opened, null: false, default: false

      t.timestamps
    end
  end
end
