class CreateMatchDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :match_details do |t|
      t.string :strengths, array: true, default: []
      t.string :strength_ids, array: true, default: []
      t.string :weaknesses, array: true, default: []
      t.string :weakness_ids, array: true, default: []
      t.integer :result_id
      t.text :details
      t.text :note_to_self
      t.datetime :played_date

      t.timestamps
    end
  end
end
