class App < Sinatra::Base
  not_found { erb :not_found }

  Sass::Plugin.options[:style] = ENV['RACK_ENV'].to_s == 'production' ? :compressed : :nested
  Sass::Plugin.options[:css_location] = 'lib/public/stylesheets'
  Sass::Plugin.options[:template_location] = 'lib/public/stylesheets/sass'

  helpers Helpers

  unless test?
    use Rack::Session::Cookie, :secret => Settings.cookie_secret
  end
  use Sass::Plugin::Rack

  register Sinatra::Flash
end
