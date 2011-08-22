require 'rubygems'
require 'bundler'
Bundler.setup

require File.join(File.dirname(__FILE__), 'blog')
run Sinatra::Application

