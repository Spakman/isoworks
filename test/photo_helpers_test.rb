require_relative "test_helper"

describe PhotoHelpers do
  include PhotoHelpers

  let(:photo) { Fixtures.photos[:html_unsafe] }
  let(:minimal_metadata_photo) { Fixtures.photos[:only_uuid_and_added_at] }
  let(:unsafe_text) { "safe > unsafe" }
  let(:html_escaped_text) { "safe &gt; unsafe" }
  let(:url_escaped_text) { "safe%20%3E%20unsafe" }
  let(:tag) { "scotland" }
  let(:collection) { "outside" }

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

    it "returns a string of the double quoted URL escaped tags viewing path" do
      assert_equal "/tags/%22#{url_escaped_text}%22", tag_path(unsafe_text)
    end

    it "returns a non-tagged photo page URL when no tag is passed" do
      assert_equal "/#{photo.uuid}", photo_page_path(photo: photo)
    end

    it "returns a tagged photo page URL when a tag is passed" do
      assert_equal "/tags/#{tag}/#{photo.uuid}", photo_page_path(photo: photo, tag: tag)
    end

    it "returns a collectioned photo page URL when a collection is passed" do
      assert_equal "/collections/#{collection}/#{photo.uuid}", photo_page_path(photo: photo, collection: collection)
    end

    describe "a photo with a broken UUID" do
      let(:photo) { OpenStruct.new(uuid: unsafe_text) }

      it "returns a string of the URL escaped photo page path" do
        assert_equal "/#{url_escaped_text}", photo_page_path(photo: photo)
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
        tags(photo)
      end

      it "renders the :tags Haml template" do
        assert_equal :tags, @haml[:template]
      end

      it "renders without a :layout" do
        refute @haml[:layout]
      end

      it "renders passing in the list of tags as a local variable" do
        assert_equal photo.tags, @haml[:tags]
      end
    end

    it "returns an empty string for the tag list when the photo has minimal metadata" do
      assert_empty tags(minimal_metadata_photo)
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

  describe "#recent_photos" do
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
        list: options.last[:locals][:list]
      }
    end

    before do
      @haml = false
      recent_photos(list)
    end

    it "renders the :recent_photos Haml template" do
      assert_equal :recent_photos, @haml[:template]
    end

    it "renders without a :layout" do
      refute @haml[:layout]
    end

    it "renders passing in the list as a local variable" do
      assert_equal list, @haml[:list]
    end
  end

  describe "the list title" do
    it "returns all photos when the tag is not set" do
      assert_equal "All photos", list_title()
    end

    it "returns an HTML escaped title when a tag is passed" do
      assert_equal "Tagged: #{html_escaped_text}", list_title(tag: unsafe_text)
    end

    it "returns an HTML escaped title when a collection is passed" do
      assert_equal "Collection: #{html_escaped_text}", list_title(collection: unsafe_text)
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
      assert_includes links, %Q{<link rel="prefetch prerender" href="#{photo_page_path(photo: third_item)}">}
    end

    it "includes a link tag that prefetches the next 1500 photo image in the list" do
      links = prefetch_and_prerender_for(photo: second_item, list: list)
      assert_includes links, %Q{<link rel="prefetch" href="#{photo_path_1500(third_item)}">}
    end

    it "returns an empty string if the item is the last in the list" do
      assert_empty prefetch_and_prerender_for(photo: third_item, list: list)
    end
  end

  describe "<link> elements" do
    let(:first_item) { Fixtures.photos[:kayak] }
    let(:second_item) { Fixtures.photos[:px3s] }
    let(:third_item) { Fixtures.photos[:tip_balance] }
    let(:fourth_item) { Fixtures.photos[:bunker_html_unsafe] }
    let(:list) do
      PhotoList.new([
        first_item,
        second_item,
        third_item,
        fourth_item
      ])
    end

    describe "#next_link" do
      it "includes the URI for the second item when the first photo is passed" do
        link = %{<link rel="next" href="#{photo_page_path(photo: second_item)}" />}
        assert_equal(link, next_link(photo: first_item, list: list))
      end

      it "returns nil when the fourth item is passed" do
        refute(next_link(photo: fourth_item, list: list))
      end
    end

    describe "#prev_link" do
      it "includes the URI for the first item when the second photo is passed" do
        link = %{<link rel="prev" href="#{photo_page_path(photo: first_item)}" />}
        assert_equal(link, prev_link(photo: second_item, list: list))
      end

      it "returns nil when the first item is passed" do
        refute(prev_link(photo: first_item, list: list))
      end
    end

    describe "#up_link" do
      it "includes /?page=1 when the first item is passed" do
        link = %{<link rel="up" href="/?page=1" />}
        assert_equal(link, up_link(photo: first_item, list: list))
      end

      it "includes /?page=2 when the fourth item is passed" do
        link = %{<link rel="up" href="/?page=2" />}
        assert_equal(link, up_link(photo: fourth_item, list: list))
      end

      it "includes /tags/tag?page=1 when the first item and a tag are passed" do
        link = %{<link rel="up" href="/tags/tag?page=1" />}
        assert_equal(link, up_link(photo: first_item, list: list, tag: "tag"))
      end

      it "includes /tags/tag?page=2 when the fourth item and a tag are passed" do
        link = %{<link rel="up" href="/tags/tag?page=2" />}
        assert_equal(link, up_link(photo: fourth_item, list: list, tag: "tag"))
      end

      it "includes /tags when a tag but no photo is passed" do
        link = %{<link rel="up" href="/tags" />}
        assert_equal(link, up_link(list: list, tag: "tag"))
      end

      it "includes /collections/collection?page=1 when the first item and a collection are passed" do
        link = %{<link rel="up" href="/collections/collection?page=1" />}
        assert_equal(link, up_link(photo: first_item, list: list, collection: "collection"))
      end

      it "includes /collections/collection?page=2 when the fourth item and a collection are passed" do
        link = %{<link rel="up" href="/collections/collection?page=2" />}
        assert_equal(link, up_link(photo: fourth_item, list: list, collection: "collection"))
      end

      it "includes /collections when a collection but no photo is passed" do
        link = %{<link rel="up" href="/collections" />}
        assert_equal(link, up_link(list: list, collection: "collection"))
      end

      it "includes / when no photo, tag or collection is passed" do
        link = %{<link rel="up" href="/" />}
        assert_equal(link, up_link(list: list))
      end
    end
  end

  describe "#filter_title" do
    it "returns nil if no tag is given" do
      refute(filter_title(tag: nil))
    end

    it 'returns "Tagged: tag" when the tag "tag" is given' do
      assert_equal("Tagged: tag", filter_title(tag: "tag"))
    end
  end

  describe "#context_count" do
    let(:photo) { :something }

    it "returns nil if a photo is given" do
      refute(context_count(photo: photo))
    end

    describe "viewing a list of photos" do
      let(:photo) { nil }

      it 'returns "3 photos" if no photo is given and a list size of 3' do
        assert_equal("3 photos", context_count(photo: photo, list: Array.new(3)))
      end

      it 'returns "1 photo" if no photo is given and a list size of 1' do
        assert_equal("1 photo", context_count(photo: photo, list: Array.new(1)))
      end

      it 'returns nil if no photo is given and a list size of 0' do
        assert_nil(context_count(photo: photo, list: Array.new(0)))
      end
    end

    describe "viewing the list of tags" do
      let(:photo) { nil }

      it 'returns "3 tags" if no photo is given and a tag_list size of 3' do
        assert_equal("3 tags", context_count(photo: photo, tag_list: Array.new(3)))
      end

      it 'returns "1 tag" if no photo is given and a tag_list size of 1' do
        assert_equal("1 tag", context_count(photo: photo, tag_list: Array.new(1)))
      end

      it 'returns nil if no photo is given and a tag_list size of 0' do
        assert_nil(context_count(photo: photo, tag_list: Array.new(0)))
      end
    end

    describe "viewing the list of collections" do
      let(:photo) { nil }

      it 'returns "3 collections" if no photo is given and a collection_list size of 3' do
        assert_equal("3 collections", context_count(photo: photo, collection_list: Array.new(3)))
      end

      it 'returns "1 collection" if no photo is given and a collection_list size of 1' do
        assert_equal("1 collection", context_count(photo: photo, collection_list: Array.new(1)))
      end

      it 'returns nil if no photo is given and a collection_list size of 0' do
        assert_nil(context_count(photo: photo, collection_list: Array.new(0)))
      end
    end
  end
end
