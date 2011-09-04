require 'rubygems'
require 'bundler'
Bundler.setup

require 'sass/plugin/rack'
use Sass::Plugin::Rack

require File.join(File.dirname(__FILE__), 'blog')
run Sinatra::Application
