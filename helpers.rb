def current_user
  return false unless session[:user]
  Admin.find(session[:user])
end

def login_required
  unless current_user
    flash[:notice] = "You must be logged in to access this area"
    redirect '/login'
  end
end
