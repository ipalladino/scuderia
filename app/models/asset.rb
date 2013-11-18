class Asset < ActiveRecord::Base
  attr_accessible :image
  belongs_to :imageable, :polymorphic => true
  
  has_attached_file :image,
      :styles => {
        :list  => "305x155#",
        :modal => "770x378#",
        :slideshow => "940x462#",
        :homepage => "1128x433#"
  }  
end
