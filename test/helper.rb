ENV['RACK_ENV'] = 'test'

require "simplecov"
SimpleCov.start do
  add_filter "/test/"
end

require "test/unit"
require "rack/test"
require "mocha"
require File.join(File.dirname(__FILE__), "..", "blog")

set :environment, :test

class Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end
end

