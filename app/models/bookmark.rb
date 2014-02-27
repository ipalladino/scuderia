class Bookmark < ActiveRecord::Base
  attr_accessible :user_id, :model_type_id, :model_id
  belongs_to  :user
  has_one     :bookmarktype
  
  def self.find_bookmark(user_id,model_type_id,model_id)
    find(
      :first,
      :conditions => ["user_id = ? AND model_type_id = ? AND model_id = ?", 
               user_id, model_type_id, model_id],
      :limit => 1
    )
  end

  def self.is_bookmarked?(user_id,model_type_id,model_id)
    print "find bookmark, user_id:#{user_id} model_type_id:#{model_type_id} model_id:#{model_id}"
    find_bookmark(user_id, model_type_id, model_id)
  end
end