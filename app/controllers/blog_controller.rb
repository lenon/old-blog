class BlogController < ApplicationController
  get "/" do
    @posts = posts_scope.desc(:created_at)
    erb :index
  end

  get "/post/:slug" do
    @post  = posts_scope.find(params[:slug]) || not_found
    @title = @post.title
    erb :post
  end

  private

  def posts_scope
    Post.where(:domain => blog_domain)
  end
end
