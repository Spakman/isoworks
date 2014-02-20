require_relative "test_helper"

describe PhotoList do
  describe "creating a list from a given directory" do
    before do
      @photo_list = PhotoList.new("test/fixtures/photos")
    end

    it "creates a list of Photos from a given directory" do
      assert_equal 7, @photo_list.photos.size
      assert_equal [ Photo ], @photo_list.photos.map(&:class).uniq
    end
  end
end
