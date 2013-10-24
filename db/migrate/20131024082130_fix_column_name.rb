class FixColumnName < ActiveRecord::Migration
  def change
    rename_column :blogs, :type, :blogtype
  end
end
