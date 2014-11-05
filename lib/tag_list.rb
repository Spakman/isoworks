require "forwardable"

class TaggedPhotos
  attr_reader :tag, :photos

  extend Forwardable

  def_delegators :@photos, :size, :first, :[]

  def initialize(tag, photos)
    @tag = tag
    @photos = photos
  end
end

class TagList < Hash

  def self.new_from_photo_list(photo_list)
    tag_list = self.new
    all_tags = photo_list.photos.map { |photo| photo.tags.to_a }.flatten.uniq
    photo_list.photos.each do |photo|
      photo.tags.each do |tag|
        tag_list[tag] ||= []
        tag_list[tag] << photo
      end
    end
    tag_list.sort
  end

  def slice(start, length)
    tag_list = []
    self.keys.slice(start, length).each do |key|
      tag_list << TaggedPhotos.new(key, self[key])
    end
    tag_list
  end

  def sort
    tag_list = TagList.new
    self.keys.sort.each do |tag|
      tag_list[tag] = self[tag]
    end
    tag_list
  end
end
