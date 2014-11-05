require "forwardable"

class CollectionedPhotos
  attr_reader :collection, :photos

  extend Forwardable

  def_delegators :@photos, :size, :first, :[]

  def initialize(collection, photos)
    @collection = collection
    @photos = photos
  end
end

class CollectionList < Hash

  def self.new_from_photo_list(photo_list)
    collection_list = self.new
    photo_list.photos.each do |photo|
      photo.collections.each do |collection|
        collection_list[collection] ||= []
        collection_list[collection] << photo
      end
    end
    collection_list.sort
  end

  def slice(start, length)
    collection_list = []
    self.keys.slice(start, length).each do |key|
      collection_list << CollectionedPhotos.new(key, self[key])
    end
    collection_list
  end

  def sort
    collection_list = CollectionList.new
    self.keys.sort.each do |collection|
      collection_list[collection] = self[collection]
    end
    collection_list
  end
end
