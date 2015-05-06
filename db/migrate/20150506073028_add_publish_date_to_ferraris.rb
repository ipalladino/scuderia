class AddPublishDateToFerraris < ActiveRecord::Migration
  def change
    add_column :ferraris, :publish_date, :datetime
  end
end
