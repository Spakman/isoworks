require_relative "test_helper"

describe PhotoList do
  before do
    @photos = PHOTO_FIXTURES.each_value.map { |fixture| Photo.new(fixture[:filepath]) }
  end

  describe "creating a photolist from an array of photos" do
    it "sets the photos attribute to be the passed photos when no tag is specified" do
      assert_equal @photos, PhotoList.new(@photos).photos
    end
  end
end
