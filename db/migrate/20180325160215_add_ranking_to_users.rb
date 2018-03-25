class AddRankingToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :ranking, :string
    add_column :users, :team, :json, array: true, :default => []
  end
end
