require "rubygems"
require "sinatra"
require "haml"
require "mongoid"
require "mongoid_slug"

Dir[File.join(File.dirname(__FILE__), 'models/**/*.rb')].each do |file|
  require file
end

configure do
  set :public, File.join(File.dirname(__FILE__), 'public')
  set :views, File.join(File.dirname(__FILE__), 'views')
  set :haml, { :format => :html5 }

  Mongoid.configure do |config|
    config.master = Mongo::Connection.new.db("my_blog")
  end
end

get "/" do
  @posts = Post.all
  haml :index
end

get "/:slug" do
  @post = Post.find_by_slug(params[:slug])
  haml :post
end

