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
        assert_kind_of Time, @photo.added_at
      end

      it "has a UUID" do
        assert_equal uuid, @photo.uuid
      end
    end

    describe "when a photo doesn't have any associated attributes" do
      let(:fixture) { Fixtures.no_metadata }

      before do
        save_no_metadata
        @photo = Photo.new("test/fixtures/no_metadata.jpg")
      end

      after do
        restore_no_metadata
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
        assert_kind_of Time, @photo.added_at
      end

      it "has a UUID" do
        assert_match UUID_CAPTURING_REGEX, @photo.uuid
      end

      it "writes the UUID to the file" do
        assert_equal @photo.uuid, Xattr.new(@photo.filepath)["user.isoworks.uuid"]
      end
    end
  end

  describe "equality" do
    it "is the same as another instance of Photo when the filepath is the same" do
      assert_equal Photo.new(Fixtures.photos[:px3s].filepath), Photo.new(Fixtures.photos[:px3s].filepath)
    end
  end
end
