class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
    @ferraris = Ferrari.paginate(page: params[:page])
    @featured = Ferrari.last(3)
    
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end

