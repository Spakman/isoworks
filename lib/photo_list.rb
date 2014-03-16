class PhotoList
  attr_reader :photos

  def initialize(photos)
    @photos = photos.sort_by { |photo| photo.added_at }
  end

  def with_tag(tag)
    PhotoList.new(@photos.find_all { |photo| photo.tags.include?(tag) })
  end

  def find(uuid)
    @photos.find { |photo| photo.uuid == uuid }
  end
end
