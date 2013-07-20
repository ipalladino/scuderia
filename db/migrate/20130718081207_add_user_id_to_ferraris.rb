class AddUserIdToFerraris < ActiveRecord::Migration
  def change
    add_column :ferraris, :user_id, :integer
    add_index :ferraris, [:user_id]
  end
  
end
