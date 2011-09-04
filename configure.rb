configure do
  env = ENV['RACK_ENV'].to_sym

  set :public, './public' # Public files
  set :views, './views'   # Templates

  # Haml options
  set :haml, {
    :format => :html5, # <3
    :ugly => (env == :production)
  }

  # Sass options
  set :sass, {
    :style => (env == :production ? :compressed : :nested)
  }

  enable :sessions
  use Rack::Flash

  Mongoid.raise_not_found_error = false
  Mongoid.configure do |config|
    config.master = Mongo::Connection.new.db("my_blog")
  end
end
