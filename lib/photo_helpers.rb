require "erb"

module PhotoHelpers
  include ERB::Util

  def small_photo_path(photo)
    "/photos/small/#{u(photo.filename)}"
  end

  def large_photo_path(photo)
    "/photos/large/#{u(photo.filename)}"
  end

  def thumb_photo_path(photo)
    "/photos/thumb/#{u(photo.filename)}"
  end

  def tag_path(tag)
    "/tags/#{u(tag)}"
  end

  def collection_path(collection)
    "/collections/#{u(collection)}"
  end

  def photo_path_1500(photo)
    "/photos/1500/#{u(photo.filename)}"
  end

  def photo_path_1200(photo)
    "/photos/1200/#{u(photo.filename)}"
  end

  def photo_path_900(photo)
    "/photos/900/#{u(photo.filename)}"
  end

  def photo_path_original(photo)
    "/photos/originals/#{u(photo.filename)}"
  end

  def image_srcset(photo)
    %Q{
    <img
      srcset="#{photo_path_1500(photo)} 1500w, #{photo_path_1200(photo)} 1200w, #{photo_path_900(photo)} 900w"
      sizes="(min-width: 1850px) 1500px, (min-width: 1550px) 1200px, (min-width: 900px) 900px, 100vw"
      alt="#{h(photo.title)}"
      src="#{photo_path_1500(photo)}"\ >
    }
  end

  def photo_page_path(photo: photo, tag: nil, collection: nil)
    if tag
      "#{tag_path(tag)}/#{u(photo.uuid)}"
    elsif collection
      "#{collection_path(collection)}/#{u(photo.uuid)}"
    else
      "/#{u(photo.uuid)}"
    end
  end

  def tags(photo)
    if photo.tags.size > 0
      haml :tags, layout: false, locals: { tags: photo.tags }
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

  def navigator(item, list)
    haml :navigator, layout: false, locals: {
      previous_item: list.item_before(item),
      next_item: list.item_after(item)
    }
  end

  def paginator(page, list)
    haml :paginator, layout: false, locals: {
      page: page,
      number_of_pages: list.number_of_pages
    }
  end

  def recent_photos(list)
    haml :recent_photos, layout: false, locals: { list: list }
  end

  def list_title(tag: nil, collection: nil)
    if tag
      "Tagged: #{h(tag)}"
    elsif collection
      "Collection: #{h(collection)}"
    else
      "All photos"
    end
  end

  def prefetch_and_prerender_for(photo: nil, list: nil)
    if item = next_item(photo: photo, list: list)
      prefetch_and_prerender_links(item)
    else
      ""
    end
  end

  def prev_link(photo: nil, list: nil, tag: nil, collection: nil)
    if photo and item = list.item_before(photo)
      %{<link rel="prev" href="#{photo_page_path(photo: item, tag: tag, collection: collection)}" />}
    end
  end

  def next_link(photo: nil, list: nil, tag: nil, collection: nil)
    if photo and item = list.item_after(photo)
      %{<link rel="next" href="#{photo_page_path(photo: item, tag: tag, collection: collection)}" />}
    end
  end

  def up_link(photo: nil, list: nil, tag: nil, collection: nil)
    if photo
      if tag
        %{<link rel="up" href="#{tag_path(tag)}?page=#{list.page_number_for(photo)}" />}
      elsif collection
        %{<link rel="up" href="#{collection_path(collection)}?page=#{list.page_number_for(photo)}" />}
      else
        %{<link rel="up" href="/?page=#{list.page_number_for(photo)}" />}
      end
    elsif tag
      %{<link rel="up" href="/tags" />}
    elsif collection
      %{<link rel="up" href="/collections" />}
    end
  end

  def filter_title(tag: nil, collection: nil)
    if tag
      "Tagged: #{tag}"
    elsif collection
      "Collection: #{collection}"
    end
  end

  def context_count(photo: nil, tag_list: nil, collection_list: nil, list: nil)
    return if photo
    if tag_list
      size = tag_list.size
      size > 1 ? "#{size} tags" : "1 tag"
    elsif collection_list
      size = collection_list.size
      size > 1 ? "#{size} collections" : "1 collection"
    elsif list
      size = list.size
      size > 1 ? "#{size} photos" : "1 photo"
    end
  end

  private

  def next_item(photo: nil, list: nil)
    if photo && list
      list.item_after(photo)
    end
  end

  def prefetch_and_prerender_links(item)
    %Q{
      <link rel="prefetch prerender" href="#{photo_page_path(photo: item)}">
      <link rel="prefetch" href="#{photo_path_1500(item)}">
    }
  end
end
