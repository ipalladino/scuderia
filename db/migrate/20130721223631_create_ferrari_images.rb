class CreateFerrariImages < ActiveRecord::Migration
  def change
    create_table :ferrari_images do |t|
      t.string :caption
      t.integer :ferrari_id

      t.timestamps
    end
  end
end
