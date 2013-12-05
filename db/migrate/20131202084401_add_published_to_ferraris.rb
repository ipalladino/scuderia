class AddPublishedToFerraris < ActiveRecord::Migration
  def change
    add_column :ferraris, :published, :boolean, :default => false
  end
end
