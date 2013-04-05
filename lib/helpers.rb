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

  def asset(src)
    return src unless ENV["RACK_ENV"] == "production"
    "http://#{Settings.assets_domain}/#{release_name}#{src}"
  end

  private

  def domain_settings
    Settings.domains[current_domain] || {}
  end

  def release_name
    @release_name ||= File.exists?(release_file_name) && File.read(release_file_name).strip
  end

  def release_file_name
    File.expand_path("RELEASE_NAME")
  end
end
