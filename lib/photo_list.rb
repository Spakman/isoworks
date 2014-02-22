class PhotoList
  attr_reader :photos

  def initialize(photos)
    @photos = photos
  end

  def with_tag(tag)
    PhotoList.new(@photos.find_all { |photo| photo.tags.include?(tag) })
  end
end
