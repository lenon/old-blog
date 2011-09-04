require "rubygems"
require "sinatra"
require "rack-flash"
require "haml"
require "mongoid"
require "mongoid_slug"

Dir[File.join(File.dirname(__FILE__), 'models/**/*.rb')].each do |file|
  require file
end

["configure", "helpers", "routes", "admin"].each do |file|
  require File.join(File.dirname(__FILE__), "#{file}")
end
