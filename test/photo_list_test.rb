require_relative "test_helper"

describe PhotoList do
  describe "creating a photolist from an array of photos" do
    it "order the passed photos by the added_at time and sets them to the photos attribute" do
      sorted_fixtures = Fixtures.photos.values.sort_by { |photo| photo.added_at }
      assert_equal sorted_fixtures, PhotoList.new(Fixtures.photos.values).photos
    end
  end

  describe "filtering" do
    it "returns a new PhotoList containing only the photos with the passed tag, sorted by added_at date" do
      sorted_fixtures = Fixtures.juggling_photos.values.sort_by { |photo| photo.added_at }
      assert_equal sorted_fixtures, PhotoList.new(Fixtures.photos.values).with_tag("juggling").photos
    end
  end
end
