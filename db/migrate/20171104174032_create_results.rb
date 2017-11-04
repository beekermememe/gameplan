class CreateResults < ActiveRecord::Migration[5.1]
  def change
    create_table :results do |t|
      t.string :sets, array: true, default: []
      t.integer :match_id
      t.timestamps
    end
  end
end
