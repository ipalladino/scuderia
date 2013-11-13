class GenericImage < ActiveRecord::Base
  attr_accessible :image, :caption
  belongs_to :car_model
  
  has_attached_file :image,
      :styles => {
        :thumb=> "100x100#",
        :small  => "300x300>",
        :modal => "770x378#",
        :slideshow => "940x462#"
        :homepage => "1203x462#"
  }
end
