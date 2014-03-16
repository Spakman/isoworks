require "sinatra"
require "erubis"
require_relative "lib/photo"
require_relative "lib/photo_list"
require_relative "lib/photo_helpers"

PHOTOS_DIRECTORY = "#{File.dirname(__FILE__)}/public/photos/originals/"

set :erb, :escape_html => true

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

  get "/:uuid" do |uuid|
    @photo = @all_photos.find(uuid)
    erb :photo
  end

  get "/tags/:tag" do |tag|
    @photo_list = @all_photos.with_tag(tag)
    erb :photo_list
  end

  run! if app_file == $0
end
