require_relative "test_helper"

describe Photo do
  describe "attributes" do
    describe "when a photo has the associated attributes" do
      let(:filepath) { "test/fixtures/photos/kayak_yellowcraigs.jpg" }
      let(:title) { "Yellowcraigs" }
      let(:description) { "I had waanted to go to Fidra since I was wee. It's pretty cool!" }
      let(:tags) { [ "north berwick", "kayaking", "east lothian", "scotland" ] }

      before do
        write_extended_attributes(filepath)
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
      it "returns nil for the title" do
        @photo = Photo.new("test/fixtures/photos/stenny_tip_balance.jpg")
        assert_nil @photo.title
      end

      it "returns nil for the description" do
        @photo = Photo.new("test/fixtures/photos/stenny_tip_balance.jpg")
        assert_nil @photo.description
      end

      it "returns an empty array for the tags" do
        @photo = Photo.new("test/fixtures/photos/stenny_tip_balance.jpg")
        assert_empty @photo.tags
      end
    end
  end
end
