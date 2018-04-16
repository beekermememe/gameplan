class AddPostMatchCommentsToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :post_match_note, :string
  end
end
