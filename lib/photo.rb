require "ffi-xattr"

class Photo
  attr_reader :uuid, :title, :description, :tags, :filepath, :filename, :added_at

  def initialize(filepath)
    @filepath = filepath
    @filename = File.basename(filepath)
    xattr = Xattr.new(filepath)
    @uuid = xattr["user.isoworks.uuid"]
    @title = xattr["user.isoworks.title"]
    @description = xattr["user.isoworks.description"]
    xattr_tags = xattr["user.isoworks.tags"]
    @added_at = xattr["user.isoworks.added_at"]
    @tags = xattr_tags ? xattr_tags.split("|") : []
  end

  def ==(object)
    object.kind_of?(self.class) && object.filepath == filepath
  end
end
