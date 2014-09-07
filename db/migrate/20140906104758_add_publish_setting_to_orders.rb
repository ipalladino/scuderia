class AddPublishSettingToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :publish_setting, :int
  end
end
