class CreateTransmissions < ActiveRecord::Migration
  def change
    create_table :transmissions do |t|
      t.string :name
      t.integer :car_model_id

      t.timestamps
    end
    add_index :transmissions, [:car_model_id]
  end
end
