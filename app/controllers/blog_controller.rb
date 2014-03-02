class BlogController < ApplicationController

  get "/" do
    @posts = Post.where(:published => true).desc(:created_at)
    erb :index
  end

  get "/post/:slug" do
    @post  = Post.find(params[:slug]) || not_found
    @title = @post.title
    erb :post
  end

  get "/rss" do
    @posts = Post.where(:published => true).desc(:created_at)
    content_type :xml
    erb :rss, :layout => false
  end
end
