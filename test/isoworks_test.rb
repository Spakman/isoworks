require_relative "test_helper"

describe Isoworks do
  include PhotoHelpers

  describe "the unfiltered photo list page" do
    let(:photos) { Fixtures.photos.values }
    let(:number_of_photos) { photos.size }

    before do
      get "/"
    end

    it "returns a success status code" do
      assert last_response.ok?
    end

    it 'sets the <title> to "All photos"' do
      assert_includes last_response.body, "<title>All photos</title>"
    end

    it "renders a list of all photos" do
      assert_equal number_of_photos, last_response.body.scan(/<li>/).size
    end

    it "displays a small image of each of the photos" do
      photos.each do |photo|
        assert_includes last_response.body, small_image(photo)
      end
    end

    it "links to each of the photo pages" do
      photos.each do |photo|
        assert_match %r{<a href="/#{photo.uuid}">}, last_response.body
      end
    end
  end

  describe "a photo page" do
    let(:photo) { Fixtures.photos[:kayak] }

    before do
      get "/#{photo.uuid}"
    end

    it "returns a 200" do
      assert last_response.ok?
    end

    it "sets the <title> to the title of the photo" do
      assert_includes last_response.body, "<title>#{photo.title}</title>"
    end

    it "renders the large photo with alternate text" do
      assert_match(/img src=".+large.+alt="/, last_response.body)
    end

    describe "rendering a photo with metadata" do
      it "renders the photo title" do
        assert last_response.body.include?(photo.title)
      end

      it "renders a list of the tags" do
        assert last_response.body.include?('<ul id="tags">')
      end
    end

    describe "rendering a photo without metadata" do
      let(:photo) { Fixtures.photos[:no_metadata] }

      it "renders an empty photo title" do
        assert_includes last_response.body, "<h1></h1>"
      end

      it "doesn't render a list of the tags" do
        refute last_response.body.include?('<ul id="tags">')
      end
    end
  end

  describe "viewing a list of photos with a certain tag" do
    let(:tag) { "juggling" }
    let(:number_of_photos) { Fixtures.juggling_photos.values.size }

    before do
      get "/tags/#{tag}"
    end

    it "returns a success status code" do
      assert last_response.ok?
    end

    it "sets the <title> to the tag" do
      assert_includes last_response.body, "<title>#{tag} photos</title>"
    end

    it "renders a list of the tagged photos" do
      assert_equal number_of_photos, last_response.body.scan(/<li>/).size
    end
  end
end
