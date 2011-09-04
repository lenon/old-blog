# Encoding: UTF-8

# 404 Not Found page
not_found do
  haml :"404"
end

# The Home page
get "/" do
  @posts = Post.all
  haml :index
end

# Single post
get "/post/:slug" do
  @post = Post.find_by_slug(params[:slug]) || not_found
  haml :post
end

#
# ADMIN AREA
#

# The Login page (GET)
get "/login" do
  haml :"admin/login"
end

# The Login page (POST)
post "/login" do
  if user = Admin.authenticate(params[:login], params[:password])
    session[:user] = user.id
    redirect "/admin"
  else
    flash.now[:alert] = "Usuário ou senha inválidos"
    haml :"admin/login"
  end
end

# The Logout
get "/logout" do
  session[:user] = nil
  redirect "/login"
end

# The Dashboard
get "/admin" do
  login_required
  haml :"admin/dashboard"
end
