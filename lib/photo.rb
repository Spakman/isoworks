require "ffi-xattr"

class Photo
  attr_reader :title, :description, :tags

  def initialize(path)
    xattr = Xattr.new(path)
    @title = xattr["user.isoworks.title"]
    @description = xattr["user.isoworks.description"]
    xattr_tags = xattr["user.isoworks.tags"]
    @tags = xattr_tags ? xattr_tags.split("|") : []
  end
end
