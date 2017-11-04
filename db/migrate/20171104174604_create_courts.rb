class CreateCourts < ActiveRecord::Migration[5.1]
  def change
    create_table :courts do |t|
      t.string :name
      t.string :street
      t.string :city
      t.string :longitude
      t.string :latitude
      t.integer :timezone
      t.string :summary
      t.string :googlemap
      t.string :email
      t.string :website
      t.string :phone
      t.string :zipcode

      t.timestamps
    end
  end
end
