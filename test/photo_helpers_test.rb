require_relative "test_helper"

describe PhotoHelpers do
  include PhotoHelpers

  let(:photo) { Fixtures.photos[:html_unsafe] }
  let(:minimal_metadata_photo) { Fixtures.photos[:only_uuid_and_added_at] }
  let(:unsafe_text) { "safe > unsafe" }
  let(:html_escaped_text) { "safe &gt; unsafe" }
  let(:url_escaped_text) { "safe%20%3E%20unsafe" }
  let(:tag) { "scotland" }

  describe "path methods" do
    let(:photo) { OpenStruct.new(filename: unsafe_text) }

    it "returns a string of the URL escaped small photo image path" do
      assert_equal "/photos/small/#{url_escaped_text}", small_photo_path(photo)
    end

    it "returns a string of the URL escaped large photo image path" do
      assert_equal "/photos/large/#{url_escaped_text}", large_photo_path(photo)
    end

    it "returns a string of the URL escaped thumb photo image path" do
      assert_equal "/photos/thumb/#{url_escaped_text}", thumb_photo_path(photo)
    end

    it "returns a string of the URL escaped tags viewing path" do
      assert_equal "/tags/#{url_escaped_text}", tag_path(unsafe_text)
    end

    it "returns a non-tagged photo page URL when no tag is passed" do
      assert_equal "/#{photo.uuid}", photo_page_path(photo)
    end

    it "returns a non-tagged photo page URL when a tag is passed" do
      assert_equal "/tags/#{tag}/#{photo.uuid}", photo_page_path(photo, tag)
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

    it "returns an empty string for the tag list when the photo has minimal metadata" do
      assert_empty tag_list(minimal_metadata_photo)
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

  describe "#navigator" do
    let(:first_item) { Fixtures.photos[:kayak] }
    let(:second_item) { Fixtures.photos[:px3s] }
    let(:third_item) { Fixtures.photos[:tip_balance] }
    let(:list) do
      PhotoList.new([
        first_item,
        second_item,
        third_item
      ])
    end

    def haml(template, *options)
      @haml = {
        template: template,
        layout: options.first[:layout],
        previous_item: options.last[:locals][:previous_item],
        next_item: options.last[:locals][:next_item]
      }
    end

    before do
      @haml = false
      navigator(second_item, list)
    end

    it "renders the :navigator Haml template" do
      assert_equal :navigator, @haml[:template]
    end

    it "renders without a :layout" do
      refute @haml[:layout]
    end

    it "renders passing in the previous item as a local variable" do
      assert_equal first_item, @haml[:previous_item]
    end

    it "renders passing in the next item as a local variable" do
      assert_equal third_item, @haml[:next_item]
    end
  end

  describe "#paginator" do
    let(:page) { 1 }
    let(:number_of_pages) { 5 }
    let(:list) { OpenStruct.new(number_of_pages: number_of_pages) }

    def haml(template, *options)
      @haml = {
        template: template,
        layout: options.first[:layout],
        page: options.last[:locals][:page],
        number_of_pages: options.last[:locals][:number_of_pages]
      }
    end

    before do
      @haml = false
      paginator(page, list)
    end

    it "renders the :paginator Haml template" do
      assert_equal :paginator, @haml[:template]
    end

    it "renders passing the page as a local variable" do
      assert_equal page, @haml[:page]
    end

    it "renders passing the number_of_pages as a local variable" do
      assert_equal number_of_pages, @haml[:number_of_pages]
    end
  end

  describe "the list title" do
    it "returns all photos when the tag is not set" do
      assert_equal "All photos", list_title(false)
    end

    it "returns an HTML escaped title when a tag is passed" do
      assert_equal "Tagged: #{html_escaped_text}", list_title(unsafe_text)
    end
  end

  describe "#prefetch_and_prerender_for" do
    let(:first_item) { Fixtures.photos[:kayak] }
    let(:second_item) { Fixtures.photos[:px3s] }
    let(:third_item) { Fixtures.photos[:tip_balance] }
    let(:list) do
      PhotoList.new([
        first_item,
        second_item,
        third_item
      ])
    end

    it "returns an empty string if the passed photo is nil" do
      assert_empty prefetch_and_prerender_for(photo: nil, list: list)
    end

    it "returns an empty string if the passed list is nil" do
      assert_empty prefetch_and_prerender_for(photo: second_item, list: nil)
    end

    it "includes a link tag that prefetches and prerenders the next item in the list" do
      links = prefetch_and_prerender_for(photo: second_item, list: list)
      assert_includes links, %Q{<link rel="prefetch prerender" href="#{photo_page_path(third_item)}">}
    end

    it "includes a link tag that prefetches the next large photo image in the list" do
      links = prefetch_and_prerender_for(photo: second_item, list: list)
      assert_includes links, %Q{<link rel="prefetch" href="#{large_photo_path(third_item)}">}
    end

    it "returns an empty string if the item is the last in the list" do
      assert_empty prefetch_and_prerender_for(photo: third_item, list: list)
    end
  end
end
