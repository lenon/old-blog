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

  def print_markdown(txt)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true)
    @markdown.render(txt)
  end

  def site_title
    domain_settings["title"]
  end

  def site_description
    domain_settings["description"]
  end

  private

  def domain_settings
    Settings.domains[current_domain] || {}
  end
end
