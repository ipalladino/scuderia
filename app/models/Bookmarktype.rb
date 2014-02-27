class Bookmarktype < ActiveRecord::Base
  attr_accessible :model
  validates_presence_of :model, :on => :create, :message => "can't be blank"  
end