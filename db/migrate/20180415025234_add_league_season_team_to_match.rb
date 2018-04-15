class AddLeagueSeasonTeamToMatch < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :season, :string
    add_column :matches, :league, :string
    add_column :matches, :team, :string
    add_column :matches, :team_id, :integer
  end
end
