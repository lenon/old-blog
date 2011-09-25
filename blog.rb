ENV['RACK_ENV'] ||= 'development'

require 'rubygems'
require 'bundler'
Bundler.require(:default, ENV['RACK_ENV'].to_sym)

require 'sass/plugin/rack'

Dir['./models/**/*.rb', './{configure,helpers,routes,admin}.rb'].each do |file|
  require file
end
