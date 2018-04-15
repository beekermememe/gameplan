class AddTeam < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :ext_id
      t.timestamps
    end
  end
end
