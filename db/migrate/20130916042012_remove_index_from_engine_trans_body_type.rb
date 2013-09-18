class RemoveIndexFromEngineTransBodyType < ActiveRecord::Migration
  def change
    remove_index :engines, [:car_model_id]
    remove_index :transmissions, [:car_model_id]
    remove_index :trims, [:car_model_id]
  end
end
