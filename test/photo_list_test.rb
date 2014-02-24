require_relative "test_helper"

describe PhotoList do
  describe "creating a photolist from an array of photos" do
    it "sets the photos attribute to be the passed photos when no tag is specified" do
      assert_equal Fixtures.photos.values, PhotoList.new(Fixtures.photos.values).photos
    end
  end

  describe "filtering" do
    it "returns a new PhotoList containing only the photos with the passed tag" do
      assert_equal Fixtures.juggling_photos.values, PhotoList.new(Fixtures.photos.values).with_tag("juggling").photos
    end
  end
end
