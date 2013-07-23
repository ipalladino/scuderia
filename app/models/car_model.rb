class CarModel < ActiveRecord::Base
  attr_accessible :car_model
  has_many :trims, dependent: :destroy
  has_many :engines, dependent: :destroy
  has_many :transmissions, dependent: :destroy
  
  belongs_to :year
  
  validates :year_id, presence: true
  validates :car_model, presence: true, length: { maximum: 140 }
  
end
