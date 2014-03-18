require_relative "test_helper"

describe PhotoHelpers do
  include PhotoHelpers

  let(:photo) { Fixtures.photos[:html_unsafe] }
  let(:no_metadata_photo) { Fixtures.photos[:no_metadata] }
  let(:unsafe_text) { "safe > unsafe" }
  let(:html_escaped_text) { "safe &gt; unsafe" }
  let(:url_escaped_text) { "safe%20%3E%20unsafe" }

  describe "path methods" do
    let(:photo) { OpenStruct.new(filename: unsafe_text) }

    it "returns a string of the URL escaped small photo image path" do
      assert_equal "/photos/small/#{url_escaped_text}", small_photo_path(photo)
    end

    it "returns a string of the URL escaped large photo image path" do
      assert_equal "/photos/large/#{url_escaped_text}", large_photo_path(photo)
    end

    it "returns a string of the URL escaped tags viewing path" do
      assert_equal "/tags/#{url_escaped_text}", tag_path(unsafe_text)
    end

    describe "a photo with a broken UUID" do
      let(:photo) { OpenStruct.new(uuid: unsafe_text) }

      it "returns a string of the URL escaped photo page path" do
        assert_equal "/#{url_escaped_text}", photo_page_path(photo)
      end
    end
  end

  describe "#tag_list" do
    describe "when the passed photo has tags" do

      def haml(template, *options)
        @haml = {
          template: template,
          layout: options.first[:layout],
          tags: options.last[:locals][:tags]
        }
      end

      before do
        @haml = false
        tag_list(photo)
      end

      it "renders the :tag_list Haml template" do
        assert_equal :tag_list, @haml[:template]
      end

      it "renders without a :layout" do
        refute @haml[:layout]
      end

      it "renders passing in the list of tags as a local variable" do
        assert_equal photo.tags, @haml[:tags]
      end
    end

    it "returns an empty string for the tag list when the photo has no metadata" do
      assert_empty tag_list(no_metadata_photo)
    end
  end

  describe "#paragraphize" do
    let(:unsafe_line_broken_text) { "A paragraph\n\n#{unsafe_text}" }
    let(:escaped_and_formatted) { "<p>A paragraph</p>\n<p>#{html_escaped_text}</p>" }

    it "returns the string without double newlines" do
      refute_includes paragraphize(unsafe_line_broken_text), "\n\n"
    end

    it "returns the text HTML escaped and with paragraph breaks" do
      assert_equal escaped_and_formatted, paragraphize(unsafe_line_broken_text)
    end

    it "returns an empty string when the text is empty" do
      assert_empty paragraphize("")
    end

    it "returns an empty string when the text parameter is nil" do
      assert_empty paragraphize(nil)
    end
  end
end
