require "singleton"

module Assets
  class Environment < Sprockets::Environment
    include Singleton

    def initialize(*args)
      super

      append_path "app/assets/javascripts"
      append_path "app/assets/stylesheets"
      append_path "app/assets/fonts"

      context_class.send(:include, Assets::Helpers)
    end
  end
end

