$:.unshift File.expand_path("..", __FILE__)

require "app/assets"
require "rake/sprocketstask"
require "uglifier"

Rake::SprocketsTask.new do |t|
  t.environment = Assets
  t.output      = "public/assets"
  t.assets      = %w(*.css *.js *.eot *.svg *.ttf *.woff)

  t.environment.css_compressor = Sprockets::SassCompressor
  t.environment.js_compressor = Uglifier.new(:mangle => true)

  t.manifest = Sprockets::Manifest.new(t.environment.index, "public/assets/manifest.json")
end

