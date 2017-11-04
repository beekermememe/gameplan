class CreateCourts < ActiveRecord::Migration[5.1]
  def change
    create_table :courts do |t|
      t.string :name
      t.text :address
      t.string :longitude
      t.string :latitude
      t.string :summary
      t.string :google_map_link
      t.string :phone
      t.integer :indoor_courts
      t.integer :outdoor_courts
      t.timestamps
    end
  end
end
