class AdminApp < App
  get '/login' do
    erb :'admin/login'
  end

  post '/login' do
    if user = Admin.authenticate(params[:login], params[:password])
      session[:admin_id] = user.id
      return redirect '/admin'
    end

    flash.now[:alert] = 'Wrong login or password'
    erb :'admin/login'
  end

  get '/logout' do
    session[:admin_id] = nil
    flash[:notice] = 'You\'re now disconnected'
    redirect '/admin/login'
  end

  get '/' do
    login_required
    erb :'admin/dashboard'
  end

  get '/new-post' do
    login_required
    @post = Post.new
    erb :'admin/new_post'
  end

  post '/new-post' do
    login_required
    @post = Post.new(params['post'])
    if @post.save
      flash[:notice] = 'Post created successfully!'
      return redirect "/post/#{@post.slug}/"
    end
    flash.now[:alert] = 'Ooops, your post cannot be created. Sorry.'
    erb :'admin/new_post'
  end

  get '/edit-post/:id' do
    login_required
    @post = Post.find(params[:id]) || not_found
    erb :'admin/edit_post'
  end

  post '/edit-post/:id' do
    login_required
    @post = Post.find(params[:id]) || not_found
    if @post.update_attributes(params["post"])
      flash[:notice] = 'Post successfully updated!'
      return redirect "/post/#{@post.slug}/"
    end
    flash.now[:alert] = 'Ooops, your post cannot be updated. Sorry.'
    erb :'admin/edit_post'
  end

  get '/delete-post/:id' do
    login_required
    @post = Post.find(params[:id]) || not_found
    erb :'admin/delete_post'
  end

  post '/delete-post/:id' do
    login_required
    @post = Post.find(params[:id]) || not_found
    @post.delete
    flash[:notice] = 'Post successfully deleted!'
    redirect '/admin'
  end

  post '/markdown-preview' do
    login_required
    print_markdown(params[:text])
  end

  get '/setup' do
    return not_found if Admin.count > 0
    erb :'admin/setup'
  end

  post '/setup' do
    return not_found if Admin.count > 0

    admin = Admin.new({
      :login => params['login'],
      :password => params['password'],
      :password_confirmation => params['password_confirmation']
    })

    if admin.save
      flash[:notice] = 'Your admin account was successfully created!'
      redirect '/admin/login'
    else
      flash.now[:alert] = 'Sorry, your account can\'t be created.'
      erb :'admin/setup'
    end
  end
end