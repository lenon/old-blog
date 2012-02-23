helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  # Render view
  def view(file)
    erb file.to_sym
  end

  # Current admin
  def current_user
    Admin.find(session[:admin_id]) if session[:admin_id]
  end

  # Redirect if user is not logged in
  def login_required
    unless current_user
      flash[:notice] = "You must be logged in to access this area"
      redirect '/login'
    end
  end

  def print_markdown(txt)
    Redcarpet.new(txt).to_html
  end

  # https://raw.github.com/emk/sinatra-url-for/master/lib/sinatra/url_for.rb
  def url_for(url_fragment, options = nil)
    optstring = nil

    if options.is_a? Hash
      optstring = '?' + options.map { |k,v| "#{k}=#{URI.escape(v.to_s, /[^#{URI::PATTERN::UNRESERVED}]/)}" }.join('&')
    end

    scheme = request.scheme
    if (scheme == 'http' && request.port == 80 ||
        scheme == 'https' && request.port == 443)
      port = "" 
    else
      port = ":#{request.port}" 
    end
    base = "#{scheme}://#{request.host}#{port}#{request.script_name}"

    "#{base}#{url_fragment}#{optstring}"
  end
end
