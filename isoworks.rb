require "sinatra"
require "haml"
require_relative "lib/photo"
require_relative "lib/photo_list"
require_relative "lib/photo_helpers"

PHOTOS_DIRECTORY = "#{File.dirname(__FILE__)}/public/photos/originals/"

class Isoworks < Sinatra::Base

  UUID_CAPTURING_REGEX = %r{(\h{8}-\h{4}-\h{4}-\h{4}-\h{12})}

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

  before do
    @tag = false
    @list = @all_photos
  end

  get "/" do
    @title = "All photos"
    haml :photo_list
  end

  get %r{^/#{UUID_CAPTURING_REGEX}} do |uuid|
    @photo = @list.find(uuid)
    @title = @photo.title
    haml :photo
  end

  get %r{^/tags/(.+)/#{UUID_CAPTURING_REGEX}} do |tag, uuid|
    @tag = tag
    @list = @all_photos.with_tag(@tag)
    @photo = @list.find(uuid)
    @title = @photo.title
    haml :photo
  end

  get "/tags/:tag" do |tag|
    @tag = tag
    @list = @all_photos.with_tag(tag)
    @title = "#{tag} photos"
    haml :photo_list
  end

  run! if app_file == $0
end
