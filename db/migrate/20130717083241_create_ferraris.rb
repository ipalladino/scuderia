class CreateFerraris < ActiveRecord::Migration
  def change
    create_table :ferraris do |t|
      t.integer :year_id
      t.integer :engine_id
      t.integer :transmission_id
      t.integer :trim_id
      t.integer :car_model_id
      t.string :title
      t.string :description
      t.integer :mileage
      t.float :price
      t.string :color
      t.string :interior_color
      t.string :vin

      t.timestamps
    end
    add_index :ferraris, [:year_id, :car_model_id, :engine_id]
  end
end
