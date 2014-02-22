require_relative "test_helper"

def photos_from_fixtures(fixtures)
  fixtures.each_value.map { |fixture| Photo.new(fixture[:filepath]) }
end

describe PhotoList do
  before do
    @photos = photos_from_fixtures(PHOTO_FIXTURES)
  end

  describe "creating a photolist from an array of photos" do
    it "sets the photos attribute to be the passed photos when no tag is specified" do
      assert_equal @photos, PhotoList.new(@photos).photos
    end
  end

  describe "filtering" do
    it "returns a new PhotoList containing only the photos with the passed tag" do
      juggling_photos = [
        Photo.new(PHOTO_FIXTURES[:tip_balance][:filepath]),
        Photo.new(PHOTO_FIXTURES[:px3s][:filepath]),
        Photo.new(PHOTO_FIXTURES[:angel_bay][:filepath])
      ]
      assert_equal juggling_photos, PhotoList.new(@photos).with_tag("juggling").photos
    end
  end
end
