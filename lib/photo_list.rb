class PhotoList
  attr_reader :photos

  def initialize(photos)
    @photos = photos.sort_by { |photo| photo.added_at }.reverse
  end

  def with_tag(tag)
    PhotoList.new(@photos.find_all { |photo| photo.tags.include?(tag) })
  end

  def find(uuid)
    @photos.find { |photo| photo.uuid == uuid }
  end

  def item_before(item)
    item_index = @photos.find_index(item)
    if item_index > 0
      @photos[item_index-1]
    else
      false
    end
  end

  def item_after(item)
    item_index = @photos.find_index(item)
    @photos[item_index+1]
  end
end
