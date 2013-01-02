require 'sinatra/base'
require 'sinatra/flash'
require 'sass/plugin/rack'

require 'lib/helpers'

class App < Sinatra::Base
  set :public_folder, 'lib/public'
  set :views, 'lib/views'

  not_found { erb :not_found }

  Sass::Plugin.options[:style] = ENV['RACK_ENV'].to_s == 'production' ? :compressed : :nested
  Sass::Plugin.options[:css_location] = 'lib/public/stylesheets'
  Sass::Plugin.options[:template_location] = 'lib/public/stylesheets/sass'

  helpers Helpers

  use Rack::Session::Cookie unless test?
  use Sass::Plugin::Rack

  register Sinatra::Flash
end