require "sinatra"
require "haml"
require_relative "lib/photo"
require_relative "lib/photo_list"
require_relative "lib/photo_helpers"

PHOTOS_DIRECTORY = "#{File.dirname(__FILE__)}/public/photos/originals/"

class Isoworks < Sinatra::Base
  helpers PhotoHelpers

  set :haml, format: :html5
  set :haml, attr_wrapper: ?"

  def initialize
    get_rid_of_haml_instance_variable_warning
    photos = Dir.glob("#{PHOTOS_DIRECTORY}*.jpg").map do |filepath|
      Photo.new(filepath)
    end
    @all_photos = PhotoList.new(photos)
    super
  end

  private def get_rid_of_haml_instance_variable_warning
    @haml_buffer = nil
  end

  get "/" do
    @photo_list = @all_photos
    @title = "All photos"
    haml :photo_list
  end

  get "/:uuid" do |uuid|
    @photo = @all_photos.find(uuid)
    @title = @photo.title
    haml :photo
  end

  get "/tags/:tag" do |tag|
    @photo_list = @all_photos.with_tag(tag)
    @title = "#{tag} photos"
    haml :photo_list
  end

  run! if app_file == $0
end
