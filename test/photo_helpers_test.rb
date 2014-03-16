require_relative "test_helper"

describe PhotoHelpers do
  include PhotoHelpers

  let(:photo) { Fixtures.photos[:kayak] }

  it "returns a string of the small photo URL" do
    assert_equal "/photos/small/#{photo.filename}", small_photo_url(photo)
  end

  it "returns a string of the large photo URL" do
    assert_equal "/photos/large/#{photo.filename}", large_photo_url(photo)
  end

  describe "a photo with metadata" do
    describe "#tag_list" do
      it 'returns an unordered list with an id of "tags"' do
        assert_match %r{^<ul id="tags">.+</ul>$}, tag_list(photo)
      end

      it "has a list item for each tag" do
        assert_equal photo.tags.length, tag_list(photo).scan(/<li>/).length
      end

      it "provides percent escaped links to the tags" do
        photo.tags.each do |tag|
          assert_includes tag_list(photo), %Q{<a href="/tags/#{tag.gsub(" ", "%20")}"}
        end
      end
    end

    describe "#description" do
      let(:html_description) { "<p>I had wanted to go to Fidra since I was wee.</p><p>It's pretty cool!</p>" }

      it "returns the description, replaces double newlines with paragraph tags" do
        assert_equal html_description, description(photo)
      end
    end
  end

  describe "a photo with no metadata" do
    let(:photo) { Fixtures.photos[:no_metadata] }

    it "returns an empty string for the tag list" do
      assert_equal "", tag_list(photo)
    end

    it "returns an empty string for the description" do
      assert_equal "", description(photo)
    end
  end

  describe "#tag_link" do
    let(:tag) { "two words" }
    let(:link) { %Q{<a href="/tags/#{tag.gsub(" ", "%20")}">#{tag}</a>} }

    it "percent escapes the href" do
      assert_equal link, tag_link(tag)
    end
  end
end
