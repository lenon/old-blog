ENV["RACK_ENV"] = "test"

unless ENV["CI"]
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
end

require 'rspec'
require 'rack/test'
require File.join File.dirname(__FILE__), '..', 'blog'

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before do
    Admin.delete_all
    Post.delete_all
  end
end
