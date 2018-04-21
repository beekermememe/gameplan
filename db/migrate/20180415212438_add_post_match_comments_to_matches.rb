class AddPostMatchCommentsToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :match_details, :post_match_notes, :string
  end
end
