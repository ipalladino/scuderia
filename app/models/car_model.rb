class CarModel < ActiveRecord::Base
  attr_accessible :car_model , :year_id,:generic_images_attributes, :generic_images
  has_many :trims, dependent: :destroy
  has_many :engines, dependent: :destroy
  has_many :transmissions, dependent: :destroy
  has_many :generic_images, dependent: :destroy
  
  belongs_to :year
  
  validates :year_id, presence: true
  validates :car_model, presence: true, length: { maximum: 140 }
  
  accepts_nested_attributes_for :generic_images, :reject_if => lambda { |a| a[:image].blank? }, :allow_destroy => true
end
