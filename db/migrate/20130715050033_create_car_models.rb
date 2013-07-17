class CreateCarModels < ActiveRecord::Migration
  def change
    create_table :car_models do |t|
      t.string :car_model
      t.integer :year_id

      t.timestamps
    end
    add_index :car_models, [:year_id]
  end
end
