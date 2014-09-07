class AddPublishedAtToFerraris < ActiveRecord::Migration
  def change
    add_column :ferraris, :published_at, :date
  end
end
