require_relative "test_helper"

describe TagList do
  let(:first_photo) { Fixtures.photos[:kayak] }
  let(:second_photo) { Fixtures.photos[:px3s] }
  let(:third_photo) { Fixtures.photos[:tip_balance] }
  let(:fourth_photo) { Fixtures.photos[:bunker_html_unsafe] }
  let(:photo_list) do
    PhotoList.new([
      first_photo,
      second_photo,
      third_photo,
      fourth_photo
    ])
  end
  let(:tag_list) { TagList.new_from_photo_list(photo_list) }

  describe "creating a TagList from a PhotoList" do
    it "has 11 entries" do
      assert_equal 12, tag_list.size
    end

    it "has alphabetically sorted keys" do
      assert_equal tag_list.keys.sort, tag_list.keys
    end

    it "has 4 photos tagged as scotland" do
      assert_equal 4, tag_list["scotland"].size
    end

    it "has one photo tagged as kayaking" do
      assert_equal [ first_photo ], tag_list["kayaking"]
    end
  end

  describe "#slice" do
    it "returns an Array with a single TaggedPhotos instance when starting at 1 and with a length of 1" do
      assert_kind_of(TaggedPhotos, tag_list.slice(1, 1).first)
      assert_equal(1, tag_list.slice(1, 1).size)
    end

    it "returns a TaggedPhotos instance with two photos when starting at 1 and with a length of 1" do
      assert_equal [ second_photo, third_photo ], tag_list.slice(1, 1).first.photos
    end

    it "returns an Array with 3 TaggedPhotos instances when starting at 1 and with a length of 3" do
      assert_equal(3, tag_list.slice(1, 3).size)
    end

    it "returns 3 TaggedPhotos instances, the second of which contains the fourth photo instance when starting at 1 and with a length of 3" do
      assert_equal [ fourth_photo ], tag_list.slice(1, 3)[1].photos
    end
  end
end

describe TaggedPhotos do
  let(:tag) { "tag" }
  let(:photos) { [ 1, 2, 3, 4, 5 ] }
  let(:tagged_photos) { TaggedPhotos.new(tag, photos) }

  it "delegates #size to the photo attribute" do
    assert_equal(photos.size, tagged_photos.size)
  end

  it "delegates #first to the photo attribute" do
    assert_equal(photos.first, tagged_photos.first)
  end

  it "delegates #[] to the photo attribute" do
    assert_equal(photos[3], tagged_photos[3])
  end
end
