class CreateGenericImages < ActiveRecord::Migration
  def change
    create_table :generic_images do |t|
      t.string :caption
      t.integer :car_model_id

      t.timestamps
    end
  end
end
