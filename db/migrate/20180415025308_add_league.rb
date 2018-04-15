class AddLeague < ActiveRecord::Migration[5.1]
  def change
    create_table :leagues do |t|
      t.string :name
      t.string :ext_id
      t.string :year
      t.timestamps
    end
  end
end
