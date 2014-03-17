require_relative "test_helper"

describe PhotoHelpers do
  include PhotoHelpers

  let(:photo) { Fixtures.photos[:html_unsafe] }
  let(:no_metadata_photo) { Fixtures.photos[:no_metadata] }
  let(:unsafe_text) { "safe > unsafe" }
  let(:html_escaped_text) { "safe &gt; unsafe" }
  let(:url_escaped_text) { "safe%20%3E%20unsafe" }

  describe "photos URL methods" do
    let(:photo) { OpenStruct.new(filename: unsafe_text) }

    it "returns a string of the URL escaped small photo URL" do
      assert_equal "/photos/small/#{url_escaped_text}", small_photo_url(photo)
    end

    it "returns a string of the URL escaped large photo URL" do
      assert_equal "/photos/large/#{url_escaped_text}", large_photo_url(photo)
    end
  end

  describe "#tag_list" do
    it 'returns an unordered list with an id of "tags"' do
      assert_match %r{^<ul id="tags">.+</ul>$}, tag_list(photo)
    end

    it "has a list item for each tag" do
      assert_equal photo.tags.length, tag_list(photo).scan(/<li>/).length
    end

    it "provides percent escaped links to the tags" do
      assert_match %r{href=".+#{url_escaped_text}"}, tag_list(photo)
    end

    it "HTML escapes the unsafe tag" do
      assert_includes tag_list(photo), html_escaped_text
    end

    it "returns an empty string for the tag list when the photo has no metadata" do
      assert_equal "", tag_list(no_metadata_photo)
    end
  end

  describe "#description" do
    let(:html_description) { "<p>A paragraph</p><p>HTML to escape: safe > unsafe</p>" }
    let(:paragraph_formatted_regex) { %r{^<p>.+?</p><p>.+?</p>$} }

    it "returns the description without newlines" do
      refute_includes "\n\n", description(photo)
    end

    it "returns the description with paragraph breaks" do
      assert_match paragraph_formatted_regex, description(photo)
    end

    it "HTML escapes the text" do
      assert_includes description(photo), html_escaped_text
    end

    it "returns an empty string for the description when the photo has no metadata" do
      assert_equal "", description(no_metadata_photo)
    end
  end

  describe "#tag_link" do
    let(:escaped_link) do
      %Q{<a href="/tags/#{url_escaped_text}">#{html_escaped_text}</a>}
    end

    it "percent escapes the href and HTML escapes the link text" do
      assert_equal escaped_link, tag_link(unsafe_text)
    end
  end

  describe "image methods" do
    let(:escaped_img) {
      %Q{<img src="#{src}" alt="#{html_escaped_text}" />}
    }

    describe "#large_image" do
      let(:src) { large_photo_url(photo) }

      it "percent escapes the src and HTML escapes the alt text" do
        assert_equal escaped_img, large_image(photo)
      end
    end

    describe "#small_image" do
      let(:src) { small_photo_url(photo) }

      it "percent escapes the src and HTML escapes the alt text" do
        assert_equal escaped_img, small_image(photo)
      end
    end
  end
end
