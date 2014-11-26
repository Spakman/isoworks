class SearchTermParser
  attr_reader :tags

  def initialize(search_terms)
    @tags = []
    search_terms.scan(/".*?"/) do |quoted_tag|
      @tags << quoted_tag
    end
    @tags.each do |tag|
      search_terms.slice!(tag)
    end
    @tags = @tags + search_terms.split
    @tags.map! { |tag| tag.gsub(?", "").strip }
  end
end
