class FerrariImage < ActiveRecord::Base
  attr_accessible :caption, :ferrari_id, :photo
  belongs_to :ferrari
  
  has_attached_file :photo, :styles => { :small => "150x150>", :large => "320x240>"}
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
end
