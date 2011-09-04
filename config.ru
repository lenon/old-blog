require 'rubygems'
require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

require 'sass/plugin/rack'
use Sass::Plugin::Rack

Dir['./models/**/*.rb', './{configure,helpers,routes,admin}.rb'].each do |file|
  require file
end

run Sinatra::Application
