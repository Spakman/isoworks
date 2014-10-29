require "securerandom"
require "time"
require "ffi-xattr"

class Photo
  attr_reader :uuid, :title, :description, :tags, :collections, :filepath, :filename, :added_at

  def initialize(filepath)
    @filepath = filepath
    @filename = File.basename(filepath)
    @xattr = Xattr.new(filepath)
    setup_uuid

    @title = read_attribute(:title) || ""
    @description = read_attribute(:description) || ""
    if time = read_attribute(:added_at)
      @added_at = Time.parse(time)
    else
      @added_at = Time.now
    end
    xattr_tags = read_attribute(:tags)
    @tags = xattr_tags ? xattr_tags.split("|") : []
    xattr_collections = read_attribute(:collections)
    @collections = xattr_collections ? xattr_collections.split("|") : []
  end

  def ==(object)
    object.kind_of?(self.class) && object.filepath == filepath
  end

  def tags=(tags)
    @tags = !tags.respond_to?(:each) ? tags = [ tags ] : tags
    write_attribute(:tags, @tags)
  end

  def collections=(collections)
    @collections = !collections.respond_to?(:each) ? collections = [ collections ] : collections
    write_attribute(:collections, @collections)
  end

  private

  def setup_uuid
    unless @uuid = read_attribute(:uuid)
      @uuid = write_attribute(:uuid, SecureRandom.uuid)
    end
  end

  def read_attribute(attribute)
    @xattr["user.isoworks.#{attribute}"]
  end

  def write_attribute(attribute, value)
    value = value.respond_to?(:each) ? value = value.join("|") : value
    @xattr["user.isoworks.#{attribute}"] = value
    value
  end
end
