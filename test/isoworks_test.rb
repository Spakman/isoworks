require_relative "test_helper"

describe Isoworks do
  it "renders a list of all photos" do
    get "/"
    assert last_response.ok?
    assert_equal Fixtures.photos.size, last_response.body.scan(/<li>/).size
  end
end
