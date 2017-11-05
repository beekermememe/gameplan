class CreateTennisDictionaries < ActiveRecord::Migration[5.1]
  def change
    create_table :tennis_dictionaries do |t|
      t.string :title
      t.string :lowercase_title
      t.timestamps
    end
  end
end
