class AddAddressToUsers < ActiveRecord::Migration
  def change
    add_column :users, :address, :string
    add_column :users, :state, :string
    add_column :users, :phone, :string
    add_column :users, :zip, :string
    add_column :users, :is_dealer, :boolean
  end
end
