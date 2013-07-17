class CreateEngines < ActiveRecord::Migration
  def change
    create_table :engines do |t|
      t.string :name
      t.integer :car_model_id

      t.timestamps
    end
    add_index :engines, [:car_model_id]
  end
end
