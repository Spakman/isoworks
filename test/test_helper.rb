require "minitest/autorun"
require_relative "../lib/photo"
require_relative "../lib/photo_list"

# Unfortunately, Git isn't able to store extended file attributes, so we need
# to write them to the files here in case this is a new checkout.
require_relative "xattrs"
