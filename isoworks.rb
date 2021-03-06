require "sinatra"
require "haml"
require_relative "lib/search_term_parser"
require_relative "lib/photo"
require_relative "lib/photo_list"
require_relative "lib/photo_helpers"
require_relative "lib/paginatable"
require_relative "lib/tag_list"
require_relative "lib/collection_list"

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
    @collection = false
    @tag_list = false
    @collection_list = false
    @page = params.fetch("page") { 1 }.to_i
    @list = @@all_photos
    @list.extend(Paginatable)
  end

  get "/" do
    @title = "All photos"
    @selected = :all
    haml :photo_list
  end

  get "/tags" do
    @title = "Tags"
    @selected = :tags
    @tag_list = TagList.new_from_photo_list(@list)
    @tag_list.extend(Paginatable)
    haml :tag_list
  end

  get "/collections" do
    @title = "collections"
    @selected = :collections
    @collection_list = CollectionList.new_from_photo_list(@list)
    @collection_list.extend(Paginatable)
    haml :collection_list
  end

  get "/import" do
    read_photos
    redirect to("/")
  end

  get %r{^/#{UUID_CAPTURING_REGEX}} do |uuid|
    @photo = @list.find(uuid)
    @title = @photo.title
    @selected = :all
    haml :photo
  end

  post %r{^/#{UUID_CAPTURING_REGEX}/add_tag} do |uuid|
    @photo = @list.find(uuid)
    @photo.add_tag(params[:tag])
  end

  post %r{^/#{UUID_CAPTURING_REGEX}/add_collection} do |uuid|
    @photo = @list.find(uuid)
    @photo.add_collection(params[:collection])
  end

  post %r{^/#{UUID_CAPTURING_REGEX}/delete_tag} do |uuid|
    @photo = @list.find(uuid)
    @photo.remove_tag(params[:tag])
  end

  post %r{^/#{UUID_CAPTURING_REGEX}/delete_collection} do |uuid|
    @photo = @list.find(uuid)
    @photo.remove_collection(params[:collection])
  end

  post %r{^/#{UUID_CAPTURING_REGEX}/delete} do |uuid|
    if @photo = @list.find(uuid)
      @photo.delete!
      read_photos
      redirect to("/")
    end
  end

  post %r{^/tags/(.+)/#{UUID_CAPTURING_REGEX}/delete} do |tag, uuid|
    if @photo = @list.find(uuid)
      @photo.delete!
      read_photos
      redirect to(tag_path(tag))
    end
  end

  post %r{^/collections/(.+)/#{UUID_CAPTURING_REGEX}/delete} do |collection, uuid|
    if @photo = @list.find(uuid)
      @photo.delete!
      read_photos
      redirect to(collection_path(collection))
    end
  end

  get %r{^/tags/(.+)/#{UUID_CAPTURING_REGEX}} do |tags, uuid|
    @tag = tags.dup
    search_parser = SearchTermParser.new(tags)

    @list = @@all_photos
    search_parser.tags.each do |tag|
      @list = @list.with_tag(tag)
    end

    @list.extend(Paginatable)
    @photo = @list.find(uuid)
    @title = @photo.title
    @selected = :tags
    haml :photo
  end

  get %r{^/collections/(.+)/#{UUID_CAPTURING_REGEX}} do |collection, uuid|
    @collection = collection
    @list = @@all_photos.with_collection(@collection)
    @list.extend(Paginatable)
    @photo = @list.find(uuid)
    @title = @photo.title
    @selected = :collections
    haml :photo
  end

  get "/tags/:tags" do |tags|
    @tag = tags.dup
    search_parser = SearchTermParser.new(tags)

    @list = @@all_photos
    search_parser.tags.each do |tag|
      @list = @list.with_tag(tag)
    end

    @list.extend(Paginatable)
    @title = "#{tags} photos"
    @selected = :tags
    haml :photo_list
  end

  get "/collections/:collection" do |collection|
    @collection = collection
    @list = @@all_photos.with_collection(collection)
    @list.extend(Paginatable)
    @title = "#{collection} photos"
    @selected = :collections
    haml :photo_list
  end

  run! if app_file == $0
end
