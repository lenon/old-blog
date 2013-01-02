ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler'

Bundler.setup

unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
  end
end

$LOAD_PATH.unshift File.expand_path('../..', __FILE__)

require 'rspec'
require 'rack/test'

require 'lib/setup'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.before do
    Admin.delete_all
    Post.delete_all
  end
end
