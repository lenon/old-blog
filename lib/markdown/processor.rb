require "singleton"

module Markdown
  class Processor
    include Singleton

    def initialize
      @redcarpet = Redcarpet::Markdown.new(
        Redcarpet::Render::HTML,
        :tables => true,
        :fenced_code_blocks => true
      )
    end

    def render(md)
      @redcarpet.render(md)
    end
  end
end

