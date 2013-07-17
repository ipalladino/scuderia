class Trim < ActiveRecord::Base
  attr_accessible :car_trim
  belongs_to :car_model
  
  validates :car_model_id, presence: true
  validates :car_trim, presence: true, length: { maximum: 140 }
end
