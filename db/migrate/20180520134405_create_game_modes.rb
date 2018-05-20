class CreateGameModes < ActiveRecord::Migration[5.1]
  def change
    create_table :game_modes do |t|
      t.string :notes
      t.integer :user_id
      t.string :strengths
      t.string :weaknesses
      t.string :post_match_notes
      t.boolean :enabled, default: false
      t.timestamps
    end

    User.all.each do |user|
      GameMode.create!(user_id: user.id)
    end
  end
end
