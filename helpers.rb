# Encoding: UTF-8
def current_user
  return false unless session[:user]
  Admin.find(session[:user])
end

def login_required
  unless current_user
    flash[:notice] = "Você precisa estar logado para acessar esta área"
    redirect '/login'
  end
end
