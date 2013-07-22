class AddAttachmentPhotoToFerrariImages < ActiveRecord::Migration
  def self.up
    change_table :ferrari_images do |t|
      t.attachment :photo
    end
  end

  def self.down
    drop_attached_file :ferrari_images, :photo
  end
end
