# Login
get "/login" do
  haml :"admin/login"
end

post "/login" do
  if user = Admin.authenticate( params[:login], params[:password] )
    session[:user] = user.id
    redirect "/admin"
  else
    flash.now[:alert] = "Wrong login or password"
    haml :"admin/login"
  end
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

  haml :"admin/dashboard"
end

# Create a new post
get "/admin/new-post" do
  login_required

  @post = Post.new
  haml :"admin/post"
end

post "/admin/new-post" do
  login_required

  @post = Post.new( params["post"] )
  if @post.save
    flash[:notice] = "Post created successfully!"
    redirect "/post/#{@post.slug}"
  else
    flash.now[:alert] = "Ooops, your post cannot be created. Sorry."
    haml :"admin/post"
  end
end

# Edit a post
get "/admin/edit-post/:id" do
  login_required

  @post = begin
      Post.find( params[:id] ) || raise
    rescue
      not_found
    end

  haml :"admin/post"
end

put "/admin/edit-post/:id" do
  login_required

  @post = begin
      Post.find( params[:id] ) || raise
    rescue
      not_found
    end

  if @post.update_attributes( params["post"] )
    flash[:notice] = "Post successfully updated!"
    redirect "/post/#{@post.slug}"
  else
    flash.now[:notice] = "Ooops, your post cannot be updated. Sorry again."
    haml :"admin/post"
  end
end
