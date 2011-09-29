configure do
  environment = ENV['RACK_ENV'].to_sym

  set :public, File.join(File.dirname(__FILE__), 'public')
  set :views, File.join(File.dirname(__FILE__), 'views')

  use Rack::Session::Cookie
  use Rack::Flash
  use Sass::Plugin::Rack

  # Sass options
  set :sass, {
    :style => (environment == :production ? :compressed : :nested)
  }

  # MongoDB settings
  Mongoid.raise_not_found_error = false
  Mongoid.configure do |config|
    config.master = Mongo::Connection.new.db("app_blog_#{environment}")
  end
end
