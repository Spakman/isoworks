module PhotoHelpers
  def small_photo_url(photo)
    "/photos/small/#{photo.filename}"
  end

  def large_photo_url(photo)
    "/photos/large/#{photo.filename}"
  end

  def tag_list(photo)
    if photo.tags.size > 0
      list = '<ul id="tags">'
      photo.tags.each do |tag|
        list << "<li>#{tag}</li>"
      end
      list << "</ul>"
    else
      ""
    end
  end

  def description(photo)
    if photo.description
      "<p>#{photo.description.gsub("\n\n", "</p><p>")}</p>"
    else
      ""
    end
  end
end
