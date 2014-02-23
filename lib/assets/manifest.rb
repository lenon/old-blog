require "singleton"
require "sprockets/manifest"

module Assets

  # The manifest contains and index of all compiled files. It is used in view
  # helpers to get the path for a compiled file.
  class Manifest < Sprockets::Manifest
    include Singleton

    def initialize
      super "public/assets" # look for public/assets/manifest-{hash}.json
    end
  end
end
