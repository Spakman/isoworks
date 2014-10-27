require "securerandom"
require "time"
require "ffi-xattr"

class Photo
  attr_reader :uuid, :title, :description, :tags, :filepath, :filename, :added_at

  def initialize(filepath)
    @filepath = filepath
    @filename = File.basename(filepath)
    xattr = Xattr.new(filepath)
    unless @uuid = xattr["user.isoworks.uuid"]
      xattr["user.isoworks.uuid"] = @uuid = SecureRandom.uuid
    end
    @title = xattr["user.isoworks.title"] || ""
    @description = xattr["user.isoworks.description"] || ""
    xattr_tags = xattr["user.isoworks.tags"]
    if time = xattr["user.isoworks.added_at"]
      @added_at = Time.parse(time)
    else
      @added_at = Time.now
    end
    @tags = xattr_tags ? xattr_tags.split("|") : []
  end

  def ==(object)
    object.kind_of?(self.class) && object.filepath == filepath
  end
end
