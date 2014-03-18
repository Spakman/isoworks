require_relative "test_helper"

describe Photo do
  describe "attributes" do
    let(:filepath) { fixture.filepath }
    let(:filename) { File.basename(filepath) }
    let(:title) { fixture.title }
    let(:description) { fixture.description }
    let(:tags) { fixture.tags }
    let(:added_at) { fixture.added_at }
    let(:uuid) { fixture.uuid }

    describe "when a photo has the associated attributes" do
      let(:fixture) { Fixtures.photos[:kayak] }

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

      it "has a filename" do
        assert_equal filename, @photo.filename
      end

      it "has a filepath" do
        assert_equal filepath, @photo.filepath
      end

      it "has an added_at Time" do
        assert_equal added_at, @photo.added_at
      end

      it "has a UUID" do
        assert_equal uuid, @photo.uuid
      end
    end

    describe "when a photo doesn't have associated attributes" do
      let(:fixture) { Fixtures.photos[:no_metadata] }

      before do
        @photo = Photo.new("test/fixtures/photos/no_metadata.jpg")
      end

      it "returns an empty string for the title" do
        assert_empty @photo.title
      end

      it "returns an empty string for the description" do
        assert_empty @photo.description
      end

      it "returns an empty array for the tags" do
        assert_empty @photo.tags
      end

      it "has a filename" do
        assert_equal filename, @photo.filename
      end

      it "has a filepath" do
        assert_equal filepath, @photo.filepath
      end

      it "has an added_at Time" do
        assert_equal added_at, @photo.added_at
      end

      it "has a UUID" do
        assert_equal uuid, @photo.uuid
      end
    end
  end

  describe "equality" do
    it "is the same as another instance of Photo when the filepath is the same" do
      assert_equal Photo.new(Fixtures.photos[:px3s].filepath), Photo.new(Fixtures.photos[:px3s].filepath)
    end
  end
end
