#
# The Blog Dashboard
#

# Login

get "/login" do
  erb :"admin/login"
end

post "/login" do
  if user = Admin.authenticate(params[:login], params[:password])
    session[:user] = user.id
    return redirect "/admin"
  end
  flash.now[:alert] = "Wrong login or password"
  erb :"admin/login"
end

# Logout

get "/logout" do
  session[:user] = nil
  flash[:notice] = "You're now disconnected"
  redirect "/login"
end

# Dashboard

get "/admin" do
  login_required
  erb :"admin/dashboard"
end

# New post

get "/admin/new-post" do
  login_required
  @post = Post.new
  erb :"admin/post"
end

post "/admin/new-post" do
  login_required
  @post = Post.new(params["post"])
  if @post.save
    flash[:notice] = "Post created successfully!"
    return redirect "/post/#{@post.slug}/"
  end
  flash.now[:alert] = "Ooops, your post cannot be created. Sorry."
  erb :"admin/post"
end

# Edit post

get "/admin/edit-post/:id" do
  login_required
  @post = Post.find(params[:id]) || not_found
  erb :"admin/post"
end

put "/admin/edit-post/:id" do
  login_required
  @post = Post.find(params[:id]) || not_found
  if @post.update_attributes(params["post"])
    flash[:notice] = "Post successfully updated!"
    return redirect "/post/#{@post.slug}/"
  end
  flash.now[:alert] = "Ooops, your post cannot be updated. Sorry again."
  erb :"admin/post"
end

# Delete post

get "/admin/delete-post/:id" do
  login_required
  @post = Post.find(params[:id]) || not_found
  erb :"admin/delete_post"
end

delete "/admin/delete-post/:id" do
  login_required
  @post = Post.find(params[:id]) || not_found
  @post.delete
  flash[:notice] = "Post successfully deleted!"
  redirect "/admin"
end

# Markdown preview

post "/admin/markdown-preview" do
  login_required
  print_markdown(params[:text])
end

# First-time setup

get "/setup" do
  return not_found if Admin.count > 0
  erb :"admin/setup"
end

post "/setup" do
  return not_found if Admin.count > 0

  admin = Admin.new({
    :login => params["login"],
    :password => params["password"],
    :password_confirmation => params["password_confirmation"]
  })

  if admin.save
    flash[:notice] = "Your admin account was successfully created!"
    redirect "/login"
  else
    flash.now[:alert] = "Ooops, your account can not be created."
    erb :"admin/setup"
  end
end
