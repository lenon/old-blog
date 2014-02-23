require "singleton"
require "ostruct"

module Assets
  class Manifest < Sprockets::Manifest
    include Singleton

    def initialize
      super "public/assets/manifest.json"
    end
  end
end

