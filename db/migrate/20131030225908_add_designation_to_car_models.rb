class AddDesignationToCarModels < ActiveRecord::Migration
  def change
    add_column :car_models, :designation, :string
    add_column :car_models, :msrp, :string
    add_column :car_models, :total_production, :string
    add_column :car_models, :engine_designer, :string
    
    add_column :car_models, :engine_configuration, :string
    add_column :car_models, :number_of_cylinders, :string
    add_column :car_models, :engine_location, :string
    add_column :car_models, :cylinder_bore, :string
    add_column :car_models, :Stroke, :string
    add_column :car_models, :displacement, :string
    add_column :car_models, :engine_material,  :string
    add_column :car_models, :compression_ratio, :string
    add_column :car_models, :horse_power, :string
    add_column :car_models, :torque, :string
    add_column :car_models, :redline, :string
    add_column :car_models, :timing, :string
    add_column :car_models, :fuel_delivery, :string
    add_column :car_models, :lubrication, :string
    
    add_column :car_models, :body_designer, :string
    add_column :car_models, :seating, :string
    add_column :car_models, :body_material, :string
    add_column :car_models, :chassis_construction, :string
    add_column :car_models, :overall_length, :string
    add_column :car_models, :overall_width, :string
    add_column :car_models, :height, :string
    add_column :car_models, :wheelbase, :string
    add_column :car_models, :steering, :string
    add_column :car_models, :fuel_capacity, :string
    add_column :car_models, :wheel_type, :string
    add_column :car_models, :wheel_size_front, :string
    add_column :car_models, :wheel_size_rear, :string
    add_column :car_models, :tire_size_front, :string
    add_column :car_models, :tire_size_rear, :string
    add_column :car_models, :tire_type, :string
    add_column :car_models, :front_brakes, :string
    add_column :car_models, :front_rotor_dimension, :string
    add_column :car_models, :rear_brakes, :string
    add_column :car_models, :rear_rotor_dimension, :string
    
    add_column :car_models, :drive_type, :string
    add_column :car_models, :gear_box, :string
    add_column :car_models, :clutch, :string
    add_column :car_models, :differential, :string
    add_column :car_models, :first_gear_ratio, :string
    add_column :car_models, :second_gear_ratio, :string
    add_column :car_models, :third_gear_ratio, :string
    add_column :car_models, :foruth_gear_ratio, :string
    add_column :car_models, :fifth_gear_ratio, :string
    add_column :car_models, :final_drive_ratio, :string

    add_column :car_models, :zero_sixty, :string
    add_column :car_models, :zero_hundred, :string
    add_column :car_models, :one_fourth_mile, :string
    add_column :car_models, :top_speed, :string
    add_column :car_models, :fuel_consumption, :string
  end
end
