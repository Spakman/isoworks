require "minitest/autorun"
require "rack/test"
require_relative "../lib/photo"
require_relative "../lib/photo_list"
require_relative "../lib/photo_helpers"
require_relative "../lib/paginatable"
require_relative "../isoworks"
ENV["RACK_ENV"] = "test"

# Unfortunately, Git isn't able to store extended file attributes, so we need
# to write them to the files here in case this is a new checkout.
require_relative "xattrs"

include Rack::Test::Methods

self.class.send(:remove_const, :PHOTOS_DIRECTORY)
PHOTOS_DIRECTORY = "#{File.dirname(__FILE__)}/fixtures/photos/"

def app
  ISOworks
end

def save_no_metadata
  FileUtils.cp("#{__dir__}/fixtures/no_metadata.jpg", "#{__dir__}/fixtures/no_metadata.jpg.original")
end

def restore_no_metadata
  FileUtils.mv("#{__dir__}/fixtures/no_metadata.jpg.original", "#{__dir__}/fixtures/no_metadata.jpg")
end

module Paginatable
  remove_const(:PER_PAGE)
  PER_PAGE = 3
end
