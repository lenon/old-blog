require 'redcarpet'

module Helpers
  include Rack::Utils
  include R18n::Helpers

  alias_method :h, :escape_html

  def current_user
    Admin.find(session[:admin_id]) if session[:admin_id]
  end

  def current_domain
    domain = request.env["HTTP_HOST"]
    Settings.domains.include?(domain) ? domain : Settings.default_domain
  end

  def login_required
    unless current_user
      flash[:notice] = "You must be logged in to access this area"
      redirect '/admin/login'
    end
  end

  def print_markdown(txt)
    Redcarpet.new(txt).to_html
  end
end
