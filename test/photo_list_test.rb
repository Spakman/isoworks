require_relative "test_helper"

describe PhotoList do
  let(:photolist) { PhotoList.new(Fixtures.photos.values) }
  let(:sorted_fixtures) do
    photolist.photos.sort_by { |photo| photo.added_at }
  end

  describe "creating a photolist from an array of photos" do
    it "order the passed photos by the added_at time and sets them to the photos attribute" do
      assert_equal sorted_fixtures, photolist.photos
    end
  end

  describe "#with_tag" do
    let(:tag) { "safe > unsafe" }
    let(:sorted_fixtures) do
      Fixtures.photos_tagged_unsafe.values.sort_by { |photo| photo.added_at }
    end

    it "returns a new PhotoList containing only photos with the passed tag" do
      photolist.with_tag(tag).photos.each do |photo|
        assert photo.tags.include?(tag), "#{photo} doesn't include tag '#{tag}'"
      end
    end

    it "sortes the photolist by added_at date" do
      assert_equal sorted_fixtures, photolist.with_tag(tag).photos
    end
  end

  describe "#find" do
    let(:photo) { Fixtures.photos[:kayak] }

    it "returns the associated photo when given a UUID" do
      assert_equal photo, photolist.find(photo.uuid)
    end
  end
end
