class BlogApp < App
  get '/' do
    @posts = Post.where(:domain => current_domain).desc(:created_at)
    erb :index
  end

  get '/post/:slug' do
    @post = Post.where(:domain => current_domain).find(params[:slug]) || not_found
    @title = @post.title
    erb :post
  end
end
