class RemoveTrims < ActiveRecord::Migration
  def change
    drop_table :trims
  end
end
