require_relative "test_helper"

describe PhotoList do
  let(:photolist) { PhotoList.new(Fixtures.photos.values.shuffle) }
  let(:sorted_fixtures) do
    Fixtures.photos.values
  end

  describe "creating a photolist from an array of photos" do
    it "order the passed photos by the added_at time and sets them to the photos attribute" do
      assert_equal sorted_fixtures, photolist.photos
    end
  end

  describe "#with_tag" do
    let(:tag) { "safe > unsafe" }
    let(:sorted_fixtures) do
      Fixtures.photos_tagged_unsafe.values
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

  describe "items around" do
    let(:first_photo) { Fixtures.photos[:kayak] }
    let(:second_photo) { Fixtures.photos[:px3s] }
    let(:third_photo) { Fixtures.photos[:tip_balance] }
    let(:photo_list) do
      PhotoList.new([
        first_photo,
        second_photo,
        third_photo
      ])
    end

    describe "#item_before" do
      it "returns the previous item in the list" do
        assert_equal first_photo, photo_list.item_before(second_photo)
      end

      it "returns false if there is no previous item" do
        refute photo_list.item_before(first_photo)
      end
    end

    describe "#item_after" do
      it "returns the next item in the list" do
        assert_equal third_photo, photo_list.item_after(second_photo)
      end

      it "returns false if there is no next item" do
        refute photo_list.item_after(third_photo)
      end
    end
  end
end
