$:.unshift File.expand_path("..", __FILE__)

require "sprockets"
require "uglifier"
require "lib/assets/helpers"
require "lib/assets/environment"
require "lib/assets/manifest"
require "rake/sprocketstask"

Rake::SprocketsTask.new do |t|
  t.environment = Assets::Environment.instance
  t.manifest    = Assets::Manifest.instance
  t.output      = "public/assets"
  t.assets      = %w(*.css *.js *.eot *.svg *.ttf *.woff *.jpg)

  t.environment.css_compressor = Sprockets::SassCompressor
  t.environment.js_compressor = Uglifier.new(:mangle => true)
end

