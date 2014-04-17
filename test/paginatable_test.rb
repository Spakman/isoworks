require_relative "test_helper"

describe Paginatable do
  let(:object) { Array(1..100) }
  let(:number_of_pages) { 34 }

  before do
    object.extend(Paginatable)
  end

  it "returns the number of pages in the paginated object" do
    assert_equal number_of_pages, object.number_of_pages
  end

  it "returns the items for a given page" do
    assert_equal Array(4..6), object.items_for_page(2)
  end

  describe "failing when the extended instance doesn't respond to required messages" do
    let(:object) { Object.new }

    it "raises a NotImplementedError error if the extended object does not respond to #size" do
      assert_raises(NotImplementedError) do
        object.size
      end
    end

    it "raises a NotImplementedError error if the extended object does not respond to #slice" do
      assert_raises(NotImplementedError) do
        object.slice(0, 10)
      end
    end
  end
end
