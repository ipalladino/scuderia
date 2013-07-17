class CreateTrims < ActiveRecord::Migration
  def change
    create_table :trims do |t|
      t.string :car_trim
      t.integer :car_model_id

      t.timestamps
    end
    add_index :trims, [:car_model_id]
  end
end
