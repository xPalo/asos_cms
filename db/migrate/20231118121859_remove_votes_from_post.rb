class RemoveVotesFromPost < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :upvotes
    remove_column :posts, :downvotes
  end
end
