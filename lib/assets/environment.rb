require "singleton"
require "sprockets"
require "lib/assets/sass_helpers"

module Assets
  class Environment < Sprockets::Environment
    include Singleton

    def initialize(*args)
      super

      append_path "app/assets/javascripts"
      append_path "app/assets/stylesheets"
      append_path "app/assets/fonts"
      append_path "app/assets/images"

      context_class.send(:include, Assets::SassHelpers)
    end
  end
end

