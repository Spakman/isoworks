module Fixtures
  attr_reader :photos, :juggling_photos
  module_function :photos, :juggling_photos

  FIXTURE_METADATA = {
    kayak: {
      filepath: "test/fixtures/photos/kayak_yellowcraigs.jpg",
      title: "Yellowcraigs",
      description: "I had waanted to go to Fidra since I was wee. It's pretty cool!",
      tags: [ "north berwick", "kayaking", "east lothian", "scotland" ]
    },
    tip_balance: {
      filepath: "test/fixtures/photos/stenny_tip_balance.jpg",
      title: "Nice tip balance by Stenny",
      tags: %w( scotland edinburgh stenny juggling )
    },
    ghost: {
      filepath: "test/fixtures/photos/mark_ghost.jpg",
      title: "Wooooo",
      tags: [ "me", "scotland", "east lothian", "seacliff" ]
    },
    px3s: {
      filepath: "test/fixtures/photos/mark_px3s.jpg",
      title: "Finally got myself some PX3s",
      tags: [ "me", "juggling", "edinburgh", "scotland", "self portrait" ]
    },
    bunker: {
      filepath: "test/fixtures/photos/mike_roc_bunker.jpg",
      title: "Garvald ROC bunker",
      tags: [ "mike", "garvald", "scotland", "east lothian" ]
    },
    angel_bay: {
      filepath: "test/fixtures/photos/stenny_juggling_angel_bay.jpg",
      title: "Stenny at Angel Bay",
      tags: [ "stenny", "juggling", "wales", "angel bay" ]
    },
    no_metadata: {
      filepath: "test/fixtures/photos/no_metadata.jpg"
    }
  }

  FIXTURE_METADATA.each_value do |fixture|
    xattr = Xattr.new(fixture[:filepath])
    xattr["user.isoworks.title"] = fixture[:title]
    xattr["user.isoworks.description"] = fixture[:description]
    xattr["user.isoworks.tags"] = fixture[:tags].join("|") if fixture[:tags]
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
