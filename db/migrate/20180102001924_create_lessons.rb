class CreateLessons < ActiveRecord::Migration[5.1]
  def change
    create_table :lessons do |t|
      t.text :coach
      t.text :notes
      t.integer :coach_id
      t.datetime :lesson_date
      t.text :coaches_note
      t.integer :user_id
      t.timestamps
    end
  end
end
