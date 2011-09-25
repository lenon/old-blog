#
# The Blog
#

# 404 - Not Found
not_found do
  erb :"404"
end

# Home page
get "/" do
  @posts = Post.all
  erb :index
end

# Post page
get "/post/:slug" do
  redirect "/post/#{params[:slug]}/", 301
end

get "/post/:slug/" do
  @post = Post.find_by_slug( params[:slug] ) || not_found
  @title = @post.title
  erb :post
end
