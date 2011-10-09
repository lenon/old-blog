ENV['RACK_ENV'] ||= 'development'
ENVIRONMENT = ENV['RACK_ENV'].to_sym
ROOT = File.join(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
Bundler.require(:default, ENVIRONMENT)

require 'yaml'
SETTINGS = YAML.load(File.open("#{ROOT}/settings.yml"))[ENVIRONMENT.to_s]

configure do
  set :public_folder, "#{ROOT}/public"
  set :views, "#{ROOT}/views"

  use Rack::Session::Cookie
  use Rack::Flash

  require 'sass/plugin/rack'
  use Sass::Plugin::Rack

  # Sass options
  set :sass, {:style => (ENVIRONMENT == :production ? :compressed : :nested)}

  # MongoDB settings
  Mongoid.raise_not_found_error = false
  Mongoid.configure.from_hash(SETTINGS["mongodb"])
end

Dir["#{ROOT}/models/**/*.rb", "#{ROOT}/{helpers,routes,admin}.rb"].each do |file|
  require file
end
