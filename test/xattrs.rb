require "securerandom"

UUID_CAPTURING_REGEX = %r{(\h{8}-\h{4}-\h{4}-\h{4}-\h{12})}

module Fixtures
  attr_reader :photos, :photos_tagged_unsafe, :photos_tagged_juggling, :no_metadata
  module_function :photos, :photos_tagged_unsafe, :photos_tagged_juggling, :no_metadata

  FIXTURE_METADATA = {
    kayak: {
      filepath: "test/fixtures/photos/kayak_yellowcraigs.jpg",
      uuid: SecureRandom.uuid,
      title: "Yellowcraigs",
      description: "I had wanted to go to Fidra since I was wee.\n\nIt is rather cool!",
      tags: [ "north berwick", "kayaking", "east lothian", "scotland" ],
      added_at: Time.now
    },
    px3s: {
      filepath: "test/fixtures/photos/mark_px3s.jpg",
      uuid: SecureRandom.uuid,
      title: "Finally got myself some PX3s",
      tags: [ "me", "juggling", "edinburgh", "scotland", "self portrait" ],
      added_at: Time.now - 50
    },
    tip_balance: {
      filepath: "test/fixtures/photos/stenny_tip_balance.jpg",
      uuid: SecureRandom.uuid,
      title: "Nice tip balance by Stenny",
      tags: %w( scotland edinburgh stenny juggling ),
      added_at: Time.now - 100
    },
    bunker_html_unsafe: {
      filepath: "test/fixtures/photos/mike_roc_bunker_html_unsafe.jpg",
      uuid: SecureRandom.uuid,
      title: "Garvald ROC bunker",
      tags: [ "mike", "garvald", "scotland", "east lothian", "safe > unsafe" ],
      added_at: Time.now - 150
    },
    html_unsafe: {
      filepath: "test/fixtures/photos/mark_ghost.jpg",
      uuid: SecureRandom.uuid,
      title: "safe > unsafe",
      description: "A paragraph\n\nHTML to escape: safe > unsafe",
      tags: [ "me", "scotland", "east lothian", "seacliff", "safe > unsafe" ],
      added_at: Time.now - 200
    },
    only_uuid_and_added_at: {
      filepath: "test/fixtures/photos/only_uuid_and_added_at.jpg",
      uuid: SecureRandom.uuid,
      added_at: Time.now - 250
    },
    angel_bay: {
      filepath: "test/fixtures/photos/stenny_juggling_angel_bay.jpg",
      uuid: SecureRandom.uuid,
      title: "Stenny at Angel Bay",
      tags: [ "stenny", "juggling", "wales", "angel bay" ],
      added_at: Time.now - 300
    }
  }

  FIXTURE_METADATA.each_value do |fixture|
    xattr = Xattr.new(fixture[:filepath])
    xattr["user.isoworks.title"] = fixture[:title]
    xattr["user.isoworks.description"] = fixture[:description]
    xattr["user.isoworks.tags"] = fixture[:tags].join("|") if fixture[:tags]
    xattr["user.isoworks.added_at"] = fixture[:added_at]
    xattr["user.isoworks.uuid"] = fixture[:uuid]
  end

  @photos = {}

  @no_metadata = Photo.new("test/fixtures/no_metadata.jpg")

  FIXTURE_METADATA.each_pair do |name, metadata|
    @photos[name] = Photo.new(metadata[:filepath])
  end

  @photos_tagged_unsafe = {
    bunker_html_unsafe: @photos[:bunker_html_unsafe],
    html_unsafe: @photos[:html_unsafe]
  }

  @photos_tagged_juggling = {
    px3: @photos[:px3s],
    tip_balance: @photos[:tip_balance],
    angel_bay: @photos[:angel_bay]
  }
end
