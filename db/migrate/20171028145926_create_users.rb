class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :club
      t.integer :club_id
      t.string :usta_number
      t.string :city
      t.string :state
      t.string :zipcode

      t.timestamps
    end
  end
end
