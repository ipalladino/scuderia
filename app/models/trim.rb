class Trim < ActiveRecord::Base
  attr_accessible :car_trim
  
  validates :car_trim, presence: true, length: { maximum: 140 }
end
