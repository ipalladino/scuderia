class CreateYears < ActiveRecord::Migration
  def change
    create_table :years do |t|
      t.string :car_year

      t.timestamps
    end
  end
end
