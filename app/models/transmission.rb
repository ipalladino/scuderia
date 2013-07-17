class Transmission < ActiveRecord::Base
  attr_accessible :name
  belongs_to :car_model
  
  validates :car_model_id, presence: true
  validates :name, presence: true, length: { maximum: 140 }
end
