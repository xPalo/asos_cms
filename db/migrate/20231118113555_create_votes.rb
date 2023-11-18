class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true, index: true
      t.references :post, null: false, foreign_key: true, index: true
      t.string :vote_type, null: false, default: 'upvote'

      t.timestamps
    end
  end
end
