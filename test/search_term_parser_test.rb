require_relative "test_helper"

describe SearchTermParser do
  describe "parsing single tag terms" do
    it "recognises a single word without spaces as a tag" do
      assert_equal(%w( tag ), SearchTermParser.new("tag").tags)
    end

    it "recognises a two words separated by a space as two tag" do
      assert_equal(%w( two tags ), SearchTermParser.new("two tags").tags)
    end

    it "recognises a two words separated by multiple spaces as two tag" do
      assert_equal(%w( two tags ), SearchTermParser.new("two  tags").tags)
    end

    it "recognises a single word enclosed in double quotes spaces as a tag" do
      assert_equal(%w( tag ), SearchTermParser.new('"tag"').tags)
    end

    it "recognises two words enclosed in double quotes spaces as a tag" do
      assert_equal([ "a tag" ], SearchTermParser.new('"a tag"').tags)
    end

    it "recognises two words enclosed in double quotes spaces followed by two single word tags" do
      assert_equal([ "a tag", "two", "more" ], SearchTermParser.new('"a tag" two more').tags)
    end

    it "recognises a single word tag followed by two words enclosed in double quotes spaces" do
      assert_equal([ "multi word", "tag" ], SearchTermParser.new('tag "multi word"').tags)
    end

    it "recognises two single word tags followed by two words enclosed in double quotes spaces" do
      assert_equal([ "multi word", "two", "more" ], SearchTermParser.new('two more "multi word"').tags)
    end

    it "recognises two multi-word tags" do
      assert_equal([ "a tag", "another tag" ], SearchTermParser.new('"a tag" "another tag"').tags)
    end
  end
end
