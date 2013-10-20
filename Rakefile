$:.unshift File.expand_path("..", __FILE__)

require "app/assets"
require "rake/sprocketstask"

Rake::SprocketsTask.new do |t|
  t.environment = Assets
  t.output      = "public/assets"
  t.assets      = %w(*.css *.js *.eot *.svg *.ttf *.woff)
end

