class AddOpponent2ToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :opponent2_id, :integer
  end
end
