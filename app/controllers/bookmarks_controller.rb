class BookmarksController < ApplicationController
  layout 'home'
  
  def show
    @user = User.find(params[:user_id])
    @bookmarks = Bookmark.find_all_by_user_id(params[:user_id]).paginate(:page => params[:page], :per_page => 10)
  end

  def toggle
    uri_array = CGI::unescape(params[:url]).split(%r{/})
    bookmark_type_id = Bookmarktype.find_by_model(uri_array[1].singularize).id
    modeltype = Bookmarktype.find_by_model(uri_array[1].singularize).model.capitalize.constantize
    model_id = modeltype.find_id_by_site_url(request.fullpath)
    
    @bookmark = Bookmark.find_bookmark(current_user.id,bookmark_type_id,model_id)
    
    # We use a delete_all here because there is no other way in Rails to delete a row from a table without a PRIMARY KEY id
    if ( @bookmark )
      Bookmark.delete_all(["user_id = ? AND model_type_id = ? AND model_id = ?", current_user.id, bookmark_type_id, model_id])
    else
      Bookmark.create( :user_id => current_user.id, :model_type_id => bookmark_type_id, :model_id => model_id)
    end
    
    render :text => "ok"
    
    #respond_to do |format|
    #  format.html
    #  format.js { render :layout => false }
    #end
    
  end

end