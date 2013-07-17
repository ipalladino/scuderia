class AddIndexToCarModelsYearId < ActiveRecord::Migration
  def change
    add_index :car_models, [:year_id]
  end
end
