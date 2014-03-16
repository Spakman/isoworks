require_relative "test_helper"

describe Isoworks do
  it "renders a list of all photos" do
    get "/"
    assert last_response.ok?
    assert_equal Fixtures.photos.size, last_response.body.scan(/<li>/).size
  end

  describe "a photo page" do
    let(:photo) { Fixtures.photos[:kayak] }

    before do
      get "/#{photo.uuid}"
    end

    it "returns a 200" do
      assert last_response.ok?
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
        assert last_response.body.include?("<h1></h1>")
      end

      it "doesn't render a list of the tags" do
        refute last_response.body.include?('<ul id="tags">')
      end
    end
  end
end
