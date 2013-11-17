class ChangeDateTypeInFerraris < ActiveRecord::Migration
  def self.up
     change_column :ferraris, :description, :text
    end

  def self.down
   change_column :my_table, :description, :string
  end
end
