class RenameStrokeTostroke < ActiveRecord::Migration
  def change
    rename_column :car_models, :Stroke, :stroke
  end
end
