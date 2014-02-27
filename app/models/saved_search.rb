class SavedSearch < ActiveRecord::Base
  attr_accessible :car_model, :keywords, :price_fr, :price_to, :user_id, :year_fr, :year_to
  belongs_to :user
end
