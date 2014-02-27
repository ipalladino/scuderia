class Ferrari < ActiveRecord::Base
  attr_accessible :car_model_id, :color, :description, :engine_id, :interior_color, :mileage, :price, :title, :transmission_id, :vin, :year_id, :assets_attributes, :assets
  belongs_to :user
  belongs_to :year
  belongs_to :car_model
  belongs_to :engine
  belongs_to :transmission
  has_many :assets, :dependent => :destroy, as: :imageable
  
  validates :car_model_id, presence: true
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
  validates :assets, presence: true
  
  def assets_urls
    urls = []
    assets.each do |a|
      urls.push({modal: a.image.url(:modal), list: a.image.url(:list), id: a.id})
    end
    return urls
  end
  
  def car_year_str
    return year.car_year
  end
  def car_model_str
    return car_model.car_model
  end
  
  def self.get_title(id)
    find_by_id(id).title
  end

  def self.get_description(id)
    find_by_id(id).description
  end
  
  def self.get_model(id)
    find_by_id(id)
  end

  def self.find_id_by_site_url(site_url)
    site_url.split(%r{/})[4]
  end
  
  accepts_nested_attributes_for :assets, :reject_if => lambda { |a| a[:image].blank? }, :allow_destroy => true
end
