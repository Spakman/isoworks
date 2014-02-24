require "ffi-xattr"

class Photo
  attr_reader :title, :description, :tags, :filepath, :filename

  def initialize(filepath)
    @filepath = filepath
    @filename = File.basename(filepath)
    xattr = Xattr.new(filepath)
    @title = xattr["user.isoworks.title"]
    @description = xattr["user.isoworks.description"]
    xattr_tags = xattr["user.isoworks.tags"]
    @tags = xattr_tags ? xattr_tags.split("|") : []
  end

  def ==(object)
    object.kind_of?(self.class) && object.filepath == filepath
  end
end
