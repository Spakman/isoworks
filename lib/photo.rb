require "securerandom"
require "time"
require "set"
require "ffi-xattr"

class Photo
  attr_reader :uuid, :title, :description, :tags, :collections, :filepath, :filename, :added_at, :taken_at, :camera, :f_stop, :exposure, :width, :height, :flash, :iso, :whitebalance, :lat, :lon, :altitude, :exposure_mode

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
    if time = read_attribute(:taken_at)
      @taken_at = Time.parse(time)
    else
      @taken_at = nil
    end
    @camera = read_attribute(:camera)
    @f_stop = read_attribute(:f_stop)
    @exposure = read_attribute(:exposure)
    @exposure_mode = read_attribute(:exposure_mode)
    @flash = read_attribute(:flash)
    @iso = read_attribute(:iso)
    @whitebalance = read_attribute(:whitebalance)
    @lat = read_attribute(:lat)
    @lon = read_attribute(:lon)
    @altitude = read_attribute(:altitude)
    @width = read_attribute(:width)
    @height = read_attribute(:height)

    xattr_tags = read_attribute(:tags)
    @tags = xattr_tags ? Set.new(xattr_tags.split("|")) : Set.new
    xattr_collections = read_attribute(:collections)
    @collections = xattr_collections ? Set.new(xattr_collections.split("|")) : Set.new
  end

  def ==(object)
    object.kind_of?(self.class) && object.filepath == filepath
  end

  def add_tag(tag)
    self.tags << tag.strip unless tag.empty?
    write_attribute(:tags, self.tags)
  end

  def remove_tag(tag)
    @tags.delete(tag)
    write_attribute(:tags, self.tags)
  end

  def add_collection(collection)
    self.collections << collection.strip unless collection.empty?
    write_attribute(:collections, self.collections)
  end

  def remove_collection(collection)
    @collections.delete(collection)
    write_attribute(:collections, self.collections)
  end

  def delete!
    FileUtils.rm(filepath)
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
    value = value.respond_to?(:each) ? value = value.to_a.join("|") : value
    @xattr["user.isoworks.#{attribute}"] = value
    value
  end
end
