require "securerandom"

module Fixtures
  attr_reader :photos, :juggling_photos
  module_function :photos, :juggling_photos

  FIXTURE_METADATA = {
    kayak: {
      filepath: "test/fixtures/photos/kayak_yellowcraigs.jpg",
      uuid: SecureRandom.uuid,
      title: "Yellowcraigs",
      description: "I had wanted to go to Fidra since I was wee.\n\nIt is rather cool!",
      tags: [ "north berwick", "kayaking", "east lothian", "scotland" ],
      added_at: Time.now
    },
    tip_balance: {
      filepath: "test/fixtures/photos/stenny_tip_balance.jpg",
      uuid: SecureRandom.uuid,
      title: "Nice tip balance by Stenny",
      tags: %w( scotland edinburgh stenny juggling ),
      added_at: Time.now - 100
    },
    html_unsafe: {
      filepath: "test/fixtures/photos/mark_ghost.jpg",
      uuid: SecureRandom.uuid,
      title: "safe > unsafe",
      description: "A paragraph\n\nHTML to escape: safe > unsafe",
      tags: [ "me", "scotland", "east lothian", "seacliff", "safe > unsafe" ],
      added_at: Time.now - 200
    },
    px3s: {
      filepath: "test/fixtures/photos/mark_px3s.jpg",
      uuid: SecureRandom.uuid,
      title: "Finally got myself some PX3s",
      tags: [ "me", "juggling", "edinburgh", "scotland", "self portrait" ],
      added_at: Time.now - 50
    },
    bunker: {
      filepath: "test/fixtures/photos/mike_roc_bunker.jpg",
      uuid: SecureRandom.uuid,
      title: "Garvald ROC bunker",
      tags: [ "mike", "garvald", "scotland", "east lothian" ],
      added_at: Time.now - 150
    },
    angel_bay: {
      filepath: "test/fixtures/photos/stenny_juggling_angel_bay.jpg",
      uuid: SecureRandom.uuid,
      title: "Stenny at Angel Bay",
      tags: [ "stenny", "juggling", "wales", "angel bay" ],
      added_at: Time.now - 300
    },
    no_metadata: {
      filepath: "test/fixtures/photos/no_metadata.jpg",
      uuid: SecureRandom.uuid,
      added_at: Time.now - 250
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

  FIXTURE_METADATA.each_pair do |name, metadata|
    @photos[name] = Photo.new(metadata[:filepath])
  end

  @juggling_photos = {
    tip_balance: @photos[:tip_balance],
    px3s: @photos[:px3s],
    angel_bay: @photos[:angel_bay]
  }
end
