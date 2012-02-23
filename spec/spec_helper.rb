ENV["RACK_ENV"] = "test"

require 'rspec'
require 'rack/test'
require File.join File.dirname(__FILE__), '..', 'blog'

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end
