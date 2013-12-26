class AddPublicsToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :public_email, :default => false
      t.boolean :public_address, :default => false
      t.boolean :public_phone, :default => false
      t.boolean :public_dealer,  :default => false
    end
  end
end
