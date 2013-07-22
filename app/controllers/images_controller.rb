class ImagesController < ApplicationController
  before_filter :signed_in_user, only: [:add_ferrari_image]
  
  def add_ferrari_image
    if remotipart_submitted?
      # do one thing
      @image = Magick::Image.read(params[:file])
      #render :text => "File has been uploaded successfully"
      render :json => "{hello : 'hayio'}"
    else
      # do another
      render :text => "No fail'o uploaded"
    end
      
      
  end
  
end
