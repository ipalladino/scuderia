class AddIndexToYearsYearId < ActiveRecord::Migration
  def change
    add_index :car_models, [:year_id, :created_at]
  end
end
