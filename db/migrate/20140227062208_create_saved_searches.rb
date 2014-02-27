class CreateSavedSearches < ActiveRecord::Migration
  def change
    create_table :saved_searches do |t|
      t.integer :user_id
      t.string :price_fr
      t.string :price_to
      t.string :year_fr
      t.string :year_to
      t.string :car_model
      t.string :keywords

      t.timestamps
    end
    add_index :saved_searches, [:user_id]
  end
end
