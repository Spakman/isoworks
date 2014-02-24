require "minitest/autorun"
require "rack/test"
require_relative "../lib/photo"
require_relative "../lib/photo_list"
require_relative "../lib/photo_helpers"
require_relative "../isoworks"
ENV["RACK_ENV"] = "test"

# Unfortunately, Git isn't able to store extended file attributes, so we need
# to write them to the files here in case this is a new checkout.
require_relative "xattrs"

include Rack::Test::Methods

self.class.send(:remove_const, :PHOTOS_DIRECTORY)
PHOTOS_DIRECTORY = "#{File.dirname(__FILE__)}/fixtures/photos/"

def app
  Isoworks
end
