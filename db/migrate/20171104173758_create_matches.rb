class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.integer :court_id
      t.integer :court_number
      t.integer :user_id
      t.integer :opponent_id
      t.integer :match_detail_id
      t.datetime :match_datetime
      t.integer :timezone
      t.integer :league_id
      t.text :result_summary
      t.text :location_summary
      t.text :opponent_summary
      t.boolean :doubles
      t.boolean :singles
      t.integer :partner_id
      t.timestamps
    end
  end
end
