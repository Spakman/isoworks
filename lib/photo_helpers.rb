require "erb"

module PhotoHelpers
  include ERB::Util

  def small_photo_path(photo)
    "/photos/small/#{u(photo.filename)}"
  end

  def large_photo_path(photo)
    "/photos/large/#{u(photo.filename)}"
  end

  def tag_path(tag)
    "/tags/#{u(tag)}"
  end

  def photo_page_path(photo)
    "/#{u(photo.uuid)}"
  end

  def tag_list(photo)
    if photo.tags.size > 0
      haml :tag_list, layout: false, locals: { tags: photo.tags }
    else
      ""
    end
  end

  def paragraphize(text)
    if text && !text.empty?
      "<p>#{h(text).gsub("\n\n", "</p>\n<p>")}</p>"
    else
      ""
    end
  end
end
