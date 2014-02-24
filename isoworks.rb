require "sinatra"
require_relative "lib/photo"
require_relative "lib/photo_list"
require_relative "lib/photo_helpers"

PHOTOS_DIRECTORY = "#{File.dirname(__FILE__)}/public/photos/"

class Isoworks < Sinatra::Base
  include PhotoHelpers

  def initialize
    photos = Dir.glob("#{PHOTOS_DIRECTORY}*.jpg").map do |filepath|
      Photo.new(filepath)
    end
    @all_photos = PhotoList.new(photos)
    super
  end

  get "/" do
    @photo_list = @all_photos
    erb :photo_list
  end

  run! if app_file == $0
end
