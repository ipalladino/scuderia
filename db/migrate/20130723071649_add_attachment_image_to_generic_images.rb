class AddAttachmentImageToGenericImages < ActiveRecord::Migration
  def change
    add_column :generic_images, :image_file_name, :string
    add_column :generic_images, :image_content_type, :string
    add_column :generic_images, :image_file_size, :integer
  end
end
