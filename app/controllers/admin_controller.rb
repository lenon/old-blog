class AdminController < ApplicationController

  set :views, "app/views/admin"

  def self.auth(*)
    condition do
      unless current_admin
        flash[:notice] = "You must be logged in to access this area"
        redirect to "/login"
      end
    end
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    if user = Admin.authenticate(params[:login], params[:password])
      session[:admin_id] = user.id
      return redirect to "/"
    end

    flash.now[:alert] = "Wrong login or password"
    erb :login
  end

  get "/logout" do
    session[:admin_id] = nil
    flash[:notice] = "You're now disconnected"

    redirect to "/login"
  end

  get "/", :auth => true do
    @posts = Post.all.order_by(:created_at => :desc)
    erb :dashboard
  end

  get "/new-post", :auth => true do
    @post = Post.new
    erb :new_post
  end

  post "/new-post", :auth => true do
    @post = Post.new(params["post"])

    if @post.save
      flash[:notice] = "Post created successfully!"
      return redirect "/post/#{@post.slug}"
    end

    flash.now[:alert] = "Ooops, your post cannot be created. Sorry."
    erb :new_post
  end

  get "/edit-post/:id", :auth => true do
    find_post
    erb :edit_post
  end

  post "/edit-post/:id", :auth => true do
    find_post

    if @post.update_attributes(params["post"])
      flash[:notice] = "Post successfully updated!"
      return redirect "/post/#{@post.slug}"
    end

    flash.now[:alert] = "Ooops, your post cannot be updated. Sorry."
    erb :edit_post
  end

  get "/delete-post/:id", :auth => true do
    find_post
    erb :delete_post
  end

  post "/delete-post/:id", :auth => true do
    find_post
    @post.delete

    flash[:notice] = "Post successfully deleted!"
    redirect to "/"
  end

  post "/markdown-preview", :auth => true do
    print_markdown(params[:text])
  end

  private

  def find_post
    @post = Post.find(params[:id]) || not_found
  end
end
