require "erb"

module PhotoHelpers
  include ERB::Util

  def small_photo_url(photo)
    "/photos/small/#{u(photo.filename)}"
  end

  def large_photo_url(photo)
    "/photos/large/#{u(photo.filename)}"
  end

  def tag_list(photo)
    if photo.tags.size > 0
      list = '<ul id="tags">'
      photo.tags.each do |tag|
        list << %Q{<li>#{tag_link(tag)}</li>}
      end
      list << "</ul>"
    else
      ""
    end
  end

  def description(photo)
    if photo.description
      "<p>#{h(photo.description).gsub("\n\n", "</p><p>")}</p>"
    else
      ""
    end
  end

  def tag_link(tag)
    %Q{<a href="/tags/#{u(tag)}">#{h(tag)}</a>}
  end

  def large_image(photo)
    %Q{<img src="#{large_photo_url(photo)}" alt="#{h(photo.title)}" />}
  end

  def small_image(photo)
    %Q{<img src="#{small_photo_url(photo)}" alt="#{h(photo.title)}" />}
  end
end
