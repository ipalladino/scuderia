module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "SCUDERIA.COM"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def get_meta(string, type)
    if(string.empty?)
      if(type == "description")
        return "A very nice Ferrari website"
      elsif(type == "title")
        return "SCUDERIA.COM"
      else
        return "some image"
      end
    else
      return string
    end
  end
  
  def get_meta_title(title, year)
    if(title.empty?)
      return "SCUDERIA.COM"
    else
      return "#{year} | #{title}"
    end
  end
end