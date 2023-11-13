class ChangePostsIsPublicColumnNull < ActiveRecord::Migration[7.0]
  def change
    change_column_default :posts, :is_public, :true
  end
end
