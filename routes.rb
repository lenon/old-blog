# 404 - Not Found
not_found do
  haml :"404"
end

# Home page
get "/" do
  @posts = Post.all
  haml :index
end

# A post
get "/post/:slug" do
  redirect "/post/#{params[:slug]}/", 301
end

get "/post/:slug/" do
  @post = Post.find_by_slug( params[:slug] ) || not_found
  @title = @post.title
  haml :post
end
