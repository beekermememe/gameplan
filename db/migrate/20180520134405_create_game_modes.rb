class CreateGameModes < ActiveRecord::Migration[5.1]
  def change
    create_table :game_modes do |t|
      t.string :note_to_self
      t.integer :user_id
      t.string :strengths, array: true, default: []
      t.string :strength_ids, array: true, default: []
      t.string :weaknesses, array: true, default: []
      t.string :weakness_ids, array: true, default: []
      t.string :post_match_notes
      t.boolean :enabled, default: false
      t.timestamps
    end

    User.all.each do |user|
      GameMode.create!(user_id: user.id)
    end
  end
end
