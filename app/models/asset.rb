class Asset < ActiveRecord::Base
  attr_accessible :image
  belongs_to :imageable, :polymorphic => true
  
  has_attached_file :image,
      :styles => {
        :thumb=> "100x100#",
        :list=> "230x120#",
        :small  => "300x300>",
        :modal => "770x378#",
        :slideshow => "940x462#",
        :homepage => "1203x462#"
  }
  
end
