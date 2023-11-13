class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.string :title, null: false
      t.string :content, null: false
      t.integer :downvotes, null: false, default: 0
      t.integer :upvotes, null: false, default: 0
      t.boolean :is_public, null: false, default: false

      t.timestamps
    end
  end
end
