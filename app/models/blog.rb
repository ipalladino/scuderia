class Blog < ActiveRecord::Base
  attr_accessible :body, :title, :blogtype, :user_id, :assets_attributes, :assets
  has_many :assets, :dependent => :destroy, as: :imageable
  belongs_to :user
  
  validates :assets, presence: true
  validates :title, presence: true
  validates :body, presence: true
  
  accepts_nested_attributes_for :assets, :reject_if => lambda { |a| a[:image].blank? }, :allow_destroy => true
end
