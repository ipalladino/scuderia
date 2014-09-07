class CreatePromoCodes < ActiveRecord::Migration
  def change
    create_table :promo_codes do |t|
      t.string :code
      t.integer :charges

      t.timestamps
    end

    add_index :promo_codes, :code, unique: true
  end
end
