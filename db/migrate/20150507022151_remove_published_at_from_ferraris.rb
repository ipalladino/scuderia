class RemovePublishedAtFromFerraris < ActiveRecord::Migration
  def change
    remove_column :ferraris, :published_at
  end
end
