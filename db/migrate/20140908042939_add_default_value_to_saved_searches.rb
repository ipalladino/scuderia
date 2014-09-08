class AddDefaultValueToSavedSearches < ActiveRecord::Migration
  def change
    remove_column :saved_searches, :price_to
    remove_column :saved_searches, :price_fr
    add_column :saved_searches, :price_to, :float, :precision => 5, :scale => 2,  :default => -1.00
    add_column :saved_searches, :price_fr, :float, :precision => 5, :scale => 2,  :default => -1.00
  end
end
