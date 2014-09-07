class AddPromoCodeIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :promo_code_id, :int
  end
end
