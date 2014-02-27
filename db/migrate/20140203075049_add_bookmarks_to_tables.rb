class AddBookmarksToTables < ActiveRecord::Migration
  def self.up
      # Note we are setting no primary key here intentionally
      create_table :bookmarks, {:id => false, :force => true} do |t|
        t.belongs_to  :user
        t.integer     :model_type_id
        t.integer     :model_id
        t.timestamps
      end

      create_table :bookmarktypes, :force => true do |t|
        t.string    :model
        t.timestamps
      end
      
      
      #Bookmarktype.create :model => 'ferrari'
      #Bookmarktype.create :model => 'car_model'
    
    end

    def self.down
      drop_table :bookmarktypes
      drop_table :bookmarks
    end
end
