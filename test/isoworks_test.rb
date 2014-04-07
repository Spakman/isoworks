require_relative "test_helper"

describe ISOworks do
  include PhotoHelpers

  let(:url_helper_output) { "http://example.org" }
  let(:html_escaped_title) { "safe &gt; unsafe" }

  it "sets the HAML format to HTML5" do
    assert_equal :html5, ISOworks.settings.haml[:format]
  end

  it "sets the HAML attr_wrapper to a double quote for nicer HTML output" do
    assert_equal ?", ISOworks.settings.haml[:attr_wrapper]
  end

  describe "the unfiltered photo list page" do
    let(:photos) { Fixtures.photos.values }
    let(:number_of_photos) { photos.size }

    before do
      get "/"
    end

    it "returns a success status code" do
      assert last_response.ok?
    end

    it 'sets the <title> to "All photos"' do
      assert_includes last_response.body, "<title>All photos</title>"
    end

    it "renders a list of all photos" do
      assert_equal number_of_photos, last_response.body.scan(/<li>/).size
    end

    it "HTML escapes the title in the list item <h2>s" do
      assert_includes last_response.body, "<h2>#{html_escaped_title}</h2>"
    end

    it "links to each of the photo pages using the #url helper" do
      photos.each do |photo|
        a_element = %Q{<a href="#{url_helper_output}#{photo_page_path(photo)}">}
        assert_includes last_response.body, a_element
      end
    end

    it "displays a small image of each of the photos using the #url helper" do
      photos.each do |photo|
        src = %Q{src="#{url_helper_output}#{small_photo_path(photo)}"}
        assert_includes last_response.body, src
      end
    end

    it "populates the alt attribute with the HTML escaped photo title" do
      photos.each do |photo|
        alt_text = %Q{alt="#{h(photo.title)}"}
        assert_includes last_response.body, alt_text
      end
    end
  end

  describe "a photo page" do
    let(:photo) { Fixtures.photos[:html_unsafe] }
    let(:escaped_title) { "<title>#{html_escaped_title}</title>" }
    let(:escaped_h1) { "<h1>#{html_escaped_title}</h1>" }
    let(:escaped_alt) do
      %r{<img alt="#{html_escaped_title}"}
    end
    let(:url_helper_src) do
      %r{<img alt=".+?" src="#{url_helper_output}#{large_photo_path(photo)}"}
    end

    before do
      get photo_page_path(photo)
    end

    it "returns a 200" do
      assert last_response.ok?
    end

    it "sets the <title> to the title of the photo" do
      assert_includes last_response.body, escaped_title
    end

    it "renders the <img> with the large photo path passed to the #url helper for the src attribute" do
      assert_match url_helper_src, last_response.body
    end

    it "renders the <img> with HTML escaped alternate text" do
      assert_match escaped_alt, last_response.body
    end

    it "renders the HTML escaped photo title" do
      assert_includes last_response.body, escaped_h1
    end

    describe "renders a tag list" do
      def link_element(tag)
        href = "#{url_helper_output}#{tag_path(tag)}"
        %Q{<a href="#{href}">#{h(tag)}</a>}
      end

      it 'has an unordered list with an id of "tags"' do
        assert_includes last_response.body, '<ul id="tags">'
      end

      it "has an <li> with a <a> for each of the tags" do
        assert_equal photo.tags.size, last_response.body.scan(/<li><a /).size
      end

      it "has a <a> element with HTML and percent escaped values that passed through the #url helper" do
        photo.tags.each do |tag|
          assert_includes last_response.body, link_element(tag)
        end
      end
    end

    describe "rendering a photo without metadata" do
      let(:photo) { Fixtures.photos[:no_metadata] }

      it "renders an empty <title> element" do
        assert_includes last_response.body, "<title></title>"
      end

      it "renders an empty photo title" do
        assert_includes last_response.body, "<h1></h1>"
      end

      it "doesn't render a list of the tags" do
        refute last_response.body.include?('<ul id="tags">')
      end

      it "doesn't render any paragraph elements" do
        refute last_response.body.include?("<p>")
      end
    end

    describe "renders a navigator" do
      it "contains a <nav> element with an id of navigator" do
        assert_match %r{<nav id="navigator">.+?</nav>}, last_response.body
      end

      describe "viewing the first photo in the list" do
        let(:photo) { Fixtures.photos[:kayak] }

        it "contains a div with a class of first" do
          assert_includes last_response.body, '<div class="first">First item</div>'
        end
      end

      describe "viewing the last photo in the list" do
        let(:photo) { Fixtures.photos[:angel_bay] }

        it "contains a div with a class of last" do
          assert_includes last_response.body, '<div class="last">Last item</div>'
        end
      end
    end
  end

  describe "viewing a photo that is part of a tagged list" do
    let(:photos) { Fixtures.photos_tagged_juggling.values }
    let(:first_photo) { photos.first }
    let(:second_photo) { photos[1] }
    let(:third_photo) { photos.last }
    let(:tag_path) { "/tags/juggling/" }
    let(:list) do
      PhotoList.new(photos)
    end

    before do
      get "#{tag_path}#{second_photo.uuid}"
    end

    it "has a link to the previous photo in the list" do
      assert_match %r{href=".+?#{tag_path}#{first_photo.uuid}"}, last_response.body
    end

    it "has a link to the next photo in the list" do
      assert_match %r{href=".+?#{tag_path}#{third_photo.uuid}"}, last_response.body
    end
  end

  describe "viewing a list of photos with a certain tag" do
    let(:tag) { "safe > unsafe" }
    let(:html_escaped_tag) { "safe &gt; unsafe" }
    let(:url_escaped_tag) { "safe%20%3E%20unsafe" }
    let(:html_escaped_title) { "<title>#{html_escaped_tag} photos</title>" }
    let(:photos) { Fixtures.photos_tagged_unsafe.values }

    before do
      get tag_path(tag)
    end

    it "returns a success status code" do
      assert last_response.ok?
    end

    it "sets the <title> to the HTML escaped tag" do
      assert_includes last_response.body, html_escaped_title
    end

    it "renders a list of the tagged photos" do
      assert_equal photos.size, last_response.body.scan(/<li>/).size
    end

    it "links to the tag specific photo page URLs" do
      photos.each do |photo|
        href = %Q{href="#{url_helper_output}/tags/#{url_escaped_tag}/#{photo.uuid}"}
        assert_includes last_response.body, href
      end
    end
  end

  describe "404" do
    it "returns a 404 if the page is not found" do
      get "/favicon.ico"
      assert_equal 404, last_response.status
    end
  end
end
