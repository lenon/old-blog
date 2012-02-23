ENV['RACK_ENV'] ||= 'development'
ENVIRONMENT = ENV['RACK_ENV'].to_sym
ROOT = File.join(File.dirname(__FILE__))

require 'rubygems'
require 'bundler'
Bundler.require(:default, ENVIRONMENT)

Mongoid.logger = nil

configure do
  set :public_folder, "#{ROOT}/public"
  set :views, "#{ROOT}/views"

  enable :sessions unless test?

  require 'sass/plugin/rack'
  use Sass::Plugin::Rack

  # Sass options
  set :sass, {:style => (ENVIRONMENT == :production ? :compressed : :nested)}

  # MongoDB settings
  Mongoid.raise_not_found_error = false
  Mongoid.configure.from_hash({
    'database' => "app_blog_#{ENVIRONMENT}"
  })
end

Dir["#{ROOT}/models/**/*.rb", "#{ROOT}/{helpers,routes,admin}.rb"].each do |file|
  require file
end
