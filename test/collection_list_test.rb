require_relative "test_helper"

describe CollectionList do
  let(:first_photo) { Fixtures.photos[:kayak] }
  let(:second_photo) { Fixtures.photos[:px3s] }
  let(:third_photo) { Fixtures.photos[:tip_balance] }
  let(:fourth_photo) { Fixtures.photos[:bunker_html_unsafe] }
  let(:fifth_photo) { Fixtures.photos[:html_unsafe] }
  let(:sixth_photo) { Fixtures.photos[:angel_bay] }
  let(:photo_list) do
    PhotoList.new([
      first_photo,
      second_photo,
      third_photo,
      fourth_photo,
      fifth_photo,
      sixth_photo
    ])
  end
  let(:collection_list) { CollectionList.new_from_photo_list(photo_list) }

  describe "creating a CollectionList from a PhotoList" do
    it "has 1 entries" do
      assert_equal 2, collection_list.size
    end

    it "has alphabetically sorted keys" do
      assert_equal collection_list.keys.sort, collection_list.keys
    end

    it "has 1 photo collectioned as wales" do
      assert_equal 1, collection_list["wales"].size
    end

    it "has 3 photos collectioned as outside" do
      assert_equal 3, collection_list["outside"].size
    end
  end

  describe "#slice" do
    it "returns an Array with a single CollectionedPhotos instance when starting at 0 and with a length of 1" do
      assert_kind_of(CollectionedPhotos, collection_list.slice(0, 1).first)
      assert_equal(1, collection_list.slice(0, 1).size)
    end

    it "returns a CollectionedPhotos instance with three photos when starting at 0 and with a length of 1" do
      assert_equal [ first_photo, fourth_photo, fifth_photo ], collection_list.slice(0, 1).first.photos
    end

    it "returns an Array with 2 CollectionedPhotos instances when starting at 0 and with a length of 2" do
      assert_equal(2, collection_list.slice(0, 2).size)
    end

    it "returns 2 CollectionedPhotos instances, the second of which contains the fourth photo instance when starting at 1 and with a length of 3" do
      assert_equal [ sixth_photo ], collection_list.slice(0, 2)[1].photos
    end
  end
end

describe CollectionedPhotos do
  let(:collection) { "collection" }
  let(:photos) { [ 1, 2, 3, 4, 5 ] }
  let(:collectioned_photos) { CollectionedPhotos.new(collection, photos) }

  it "delegates #size to the photo attribute" do
    assert_equal(photos.size, collectioned_photos.size)
  end

  it "delegates #first to the photo attribute" do
    assert_equal(photos.first, collectioned_photos.first)
  end

  it "delegates #[] to the photo attribute" do
    assert_equal(photos[3], collectioned_photos[3])
  end
end
