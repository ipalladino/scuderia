class AddImageableTypeAndImageableIdToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :imageable_type, :string
    add_column :assets, :imageable_id, :integer
  end
end
