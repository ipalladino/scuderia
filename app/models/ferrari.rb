class Ferrari < ActiveRecord::Base
  attr_accessible :car_model_id, :color, :description, :engine_id, :interior_color, :mileage, :price, :title, :transmission_id, :vin, :year_id, :assets_attributes, :assets
  belongs_to :user
  belongs_to :year
  belongs_to :car_model
  belongs_to :engine
  belongs_to :transmission
  has_many :assets, :dependent => :destroy, as: :imageable
  has_one :order

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

  def expired?
    if(self.published)

      begin
        publish_type = self.order.publish_setting
      rescue
        puts "Ferrari Model, expired? - no order setting - we will do nothing"
        return false
      end

      begin
        days_since_creation = (Time.zone.now - self.publish_date) / 3600 / 24
      rescue
        puts "Ferrari Model, expired? - There seems to be no publish date - we will do nothing"
        return false
      end

      if(publish_type == 0)
        #if publish setting is 0 expires in 1 year
        if(days_since_creation > 365)
          if(self.expire)
            return true
          end
        else
          return false
        end
      elsif(publish_type == 1)
        #setting 1 expires in 3 months
        if(days_since_creation > 93)
          if(self.expire)
            return true
          else
            return false
          end
        end
      elsif(publish_type == 2)
        #setting 2 expires in 1 month
        if(days_since_creation > 31)
          if(self.expire)
            return true
          else
            return false
          end
        end
      end
    else
      return true
    end
  end

  def publish
    self.publish_date = DateTime.now
    self.published = true
    self.save
    UserNotifier.send_ferrari_published_notification(self).deliver
  end

  def expire
    #we should send an email notification letting the user know that his item has expired
    puts "THIS FERRARI HAS EXPIRED!!!!!! #{self.id}"
    self.published = false
    self.save
    UserNotifier.send_expired_ferrari_notification(self).deliver
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
