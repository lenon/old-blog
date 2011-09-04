configure do
  set :public, File.join(File.dirname(__FILE__), 'public')
  set :views, File.join(File.dirname(__FILE__), 'views')
  set :haml, { :format => :html5 }

  enable :sessions
  use Rack::Flash

  Mongoid.raise_not_found_error = false
  Mongoid.configure do |config|
    config.master = Mongo::Connection.new.db("my_blog")
  end
end
