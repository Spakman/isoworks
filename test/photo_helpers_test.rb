require_relative "test_helper"

describe PhotoHelpers do
  include PhotoHelpers

  let(:photo) { Fixtures.photos[:kayak] }

  it "returns a string of the small photo URL" do
    assert_equal "/photos/small/#{photo.filename}", small_photo_url(photo)
  end
end
