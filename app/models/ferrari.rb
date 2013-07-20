class Ferrari < ActiveRecord::Base
  attr_accessible :car_model_id, :color, :description, :engine_id, :interior_color, :mileage, :price, :title, :transmission_id, :trim_id, :vin, :year_id
  belongs_to :user
  belongs_to :year
  belongs_to :car_model
  belongs_to :engine
  belongs_to :trim
  belongs_to :transmission
  
  validates :car_model_id, presence: true
  validates :trim_id, presence: true
  validates :year_id, presence: true
  validates :engine_id, presence: true
  validates :transmission_id, presence: true
  validates :interior_color, presence: true
  validates :mileage, presence: true
  validates :price, presence: true
  validates :title, presence: true
  validates :vin, presence: true
  validates :color, presence: true
  validates :user, presence: true
  
end
