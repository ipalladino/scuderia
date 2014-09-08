class AddNotifyMeIdToSavedSearchs < ActiveRecord::Migration
  def change
    add_column :saved_searches, :notify_me, :boolean
  end
end
