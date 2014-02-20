require "minitest/autorun"
require_relative "../lib/photo"

# Unfortunately, Git isn't able to store extended file attributes, so we need
# to write them to the files here in case this is a new checkout.
def write_extended_attributes(filepath)
  xattr = Xattr.new(filepath)
  xattr["user.isoworks.title"] = title
  xattr["user.isoworks.description"] = description
  xattr["user.isoworks.tags"] = tags.join("|")
end
