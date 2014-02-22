require_relative "test_helper"

describe Photo do
  describe "attributes" do
    describe "when a photo has the associated attributes" do
      let(:fixture) { PHOTO_FIXTURES[:kayak] }
      let(:filepath) { fixture[:filepath] }
      let(:title) { fixture[:title] }
      let(:description) { fixture[:description] }
      let(:tags) { [ "north berwick", "kayaking", "east lothian", "scotland" ] }

      before do
        @photo = Photo.new(filepath)
      end

      it "has a title" do
        assert_equal title, @photo.title
      end

      it "has a description" do
        assert_equal description, @photo.description
      end

      it "has tags" do
        assert_equal tags, @photo.tags
      end
    end

    describe "when a photo doesn't have associated attributes" do
      before do
        @photo = Photo.new("test/fixtures/photos/no_metadata.jpg")
      end

      it "returns nil for the title" do
        assert_nil @photo.title
      end

      it "returns nil for the description" do
        assert_nil @photo.description
      end

      it "returns an empty array for the tags" do
        assert_empty @photo.tags
      end
    end
  end

  describe "equality" do
    it "is the same as another instance of Photo when the filepath is the same" do
      assert_equal Photo.new(PHOTO_FIXTURES[:px3s][:filepath]), Photo.new(PHOTO_FIXTURES[:px3s][:filepath])
    end
  end
end
