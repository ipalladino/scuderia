module BookmarksHelper

  # Make sure that self.find_id_by_site_url is in every model that can be bookmarked
  def bookmarked?(user_id, model_id, request_uri)
    uri_array = request_uri.split(%r{/})
    bookmark_type_id = Bookmarktype.find_by_model(uri_array[1].singularize).id
    modeltype = Bookmarktype.find_by_model(uri_array[1].singularize).model.capitalize.constantize
    return Bookmark.is_bookmarked?(user_id,bookmark_type_id,model_id)
  end
  
  def print_bookmark_type(model_type_id)
    Bookmarktype.find(model_type_id).model.capitalize
  end
  
  # Make sure that self.get_title is in every model that can be bookmarked
  def link_to_bookmark(anchor_text,bookmark)
    controller = Bookmarktype.find(bookmark.model_type_id).model.pluralize
    title = Bookmarktype.find(bookmark.model_type_id).model.capitalize.constantize.get_title(bookmark.model_id)
    @item = Bookmarktype.find(bookmark.model_type_id).model.capitalize.constantize.find_by_id(bookmark.model_id)
    link_to "#{anchor_text}. #{title}", send("#{controller.singularize}_path", @item)
  end
  
  # Make sure that self.get_description is in every model that can be bookmarked
  def print_bookmark_desc(bookmark)
    Bookmarktype.find(bookmark.model_type_id).model.capitalize.constantize.get_description(bookmark.model_id)
  end
  
  def get_model_from_bookmark(bookmark)
    Bookmarktype.find(bookmark.model_type_id).model.capitalize.constantize.get_model(bookmark.model_id)
  end
end