class Year < ActiveRecord::Base
  attr_accessible :car_year
  has_many :car_models, dependent: :destroy
  
  validates :car_year,  presence:   true,
                        format:     { with: /\d/ },
                        uniqueness: { case_sensitive: false }
end
