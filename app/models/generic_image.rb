class GenericImage < ActiveRecord::Base
  attr_accessible :image, :caption
  belongs_to :car_model
  
  has_attached_file :image,
      :styles => {
        :list => "308x227#",
        :modal => "770x378#",
        :slideshow => "940x462#",
        :homepage => "1128x433#"
  }
end
