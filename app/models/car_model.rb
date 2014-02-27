class CarModel < ActiveRecord::Base
  attr_accessible :car_model , :year_id,:generic_images_attributes, :generic_images
  attr_accessible :designation, :msrp, :total_production, :engine_designer, :engine_configuration,  :number_of_cylinders, :engine_location, :cylinder_bore, :stroke, :displacement, :engine_material, :compression_ratio, :horse_power, :torque,  :redline, :timing,  :fuel_delivery, :lubrication, :body_designer, :seating, :body_material, :chassis_construction, :overall_length,  :overall_width, :height,  :wheelbase, :steering, :fuel_capacity, :wheel_type, :wheel_size_front, :wheel_size_rear, :tire_size_front, :tire_size_rear,  :tire_type, :front_brakes,  :front_rotor_dimension, :rear_brakes, :rear_rotor_dimension, :drive_type, :gear_box, :clutch, :differential, :first_gear_ratio, :second_gear_ratio, :third_gear_ratio, :foruth_gear_ratio, :fifth_gear_ratio, :final_drive_ratio, :zero_sixty, :zero_hundred, :one_fourth_mile, :top_speed, :fuel_consumption
  
  has_many :engines, dependent: :destroy
  has_many :transmissions, dependent: :destroy
  has_many :generic_images, dependent: :destroy
  
  belongs_to :year
  
  validates :year_id, presence: true
  validates :car_model, presence: true, length: { maximum: 140 }
  
  def actual_year
    self.year.car_year
  end
  
  def assets_urls
    urls = []
    generic_images.each do |a|
      urls.push({modal: a.image.url(:modal), list: a.image.url(:list)})
    end
    return urls
  end
  
  def car_year_str
    return year.car_year
  end
  
  def self.get_title(id)
    find_by_id(id).car_model
  end

  def self.get_description(id)
    find_by_id(id).car_year_str
  end

  def self.find_id_by_site_url(site_url)
    site_url.split(%r{/})[4]
  end
  
  accepts_nested_attributes_for :generic_images, :reject_if => lambda { |a| a[:image].blank? }, :allow_destroy => true
end
