class BlogApp < App
  get '/' do
    @posts = Post.order_by(:created_at, :desc)
    erb :index
  end

  get '/post/:slug' do
    redirect "/post/#{params[:slug]}/", 301
  end

  get '/post/:slug/' do
    @post = Post.find_by_slug(params[:slug]) || not_found
    @title = @post.title
    erb :post
  end
end