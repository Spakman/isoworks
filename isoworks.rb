require "sinatra"
require "haml"
require_relative "lib/photo"
require_relative "lib/photo_list"
require_relative "lib/photo_helpers"
require_relative "lib/paginatable"
require_relative "lib/tag_list"

PHOTOS_DIRECTORY = "#{File.dirname(__FILE__)}/public/photos/originals/"

class ISOworks < Sinatra::Base

  UUID_CAPTURING_REGEX = %r{(\h{8}-\h{4}-\h{4}-\h{4}-\h{12})}

  helpers PhotoHelpers

  set :haml, format: :html5
  set :haml, attr_wrapper: ?"
  set :bind, '0.0.0.0'

  def initialize
    get_rid_of_haml_instance_variable_warning
    read_photos
    super
  end

  private def get_rid_of_haml_instance_variable_warning
    @haml_buffer = nil
  end

  private def read_photos
    photos = Dir.glob("#{PHOTOS_DIRECTORY}*.jpg").map do |filepath|
      Photo.new(filepath)
    end
    @@all_photos = PhotoList.new(photos)
  end

  before do
    @photo = false
    @tag = false
    @page = params.fetch("page") { 1 }.to_i
    @list = @@all_photos
    @list.extend(Paginatable)
  end

  get "/" do
    @title = "All photos"
    haml :photo_list
  end

  get "/tags" do
    @title = "Tags"
    @tag_list = TagList.new_from_photo_list(@list)
    @tag_list.extend(Paginatable)
    haml :tag_list
  end

  get "/import" do
    read_photos
    redirect to("/")
  end

  get %r{^/#{UUID_CAPTURING_REGEX}} do |uuid|
    @photo = @list.find(uuid)
    @title = @photo.title
    haml :photo
  end

  post %r{^/#{UUID_CAPTURING_REGEX}/add_tag} do |uuid|
    @photo = @list.find(uuid)
    @photo.tags = @photo.tags << params[:tag]
  end

  post %r{^/#{UUID_CAPTURING_REGEX}/delete_tag} do |uuid|
    @photo = @list.find(uuid)
    @photo.tags = @photo.remove_tag(params[:tag])
  end

  get %r{^/tags/(.+)/#{UUID_CAPTURING_REGEX}} do |tag, uuid|
    @tag = tag
    @list = @@all_photos.with_tag(@tag)
    @list.extend(Paginatable)
    @photo = @list.find(uuid)
    @title = @photo.title
    haml :photo
  end

  get "/tags/:tag" do |tag|
    @tag = tag
    @list = @@all_photos.with_tag(tag)
    @list.extend(Paginatable)
    @title = "#{tag} photos"
    haml :photo_list
  end

  run! if app_file == $0
end
