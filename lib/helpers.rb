require 'redcarpet'

module Helpers
  include Rack::Utils
  include R18n::Helpers

  alias_method :h, :escape_html

  def current_user
    Admin.find(session[:admin_id]) if session[:admin_id]
  end

  def blog_settings
    BlogSettings.new(request.env["HTTP_HOST"])
  end

  def blog_title
    blog_settings.title
  end

  def blog_description
    blog_settings.description
  end

  def blog_domain
    blog_settings.domain
  end

  def page_title
    return blog_settings.home_title unless @title.present?
    blog_settings.post_title % @title
  end

  def print_markdown(txt)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true)
    @markdown.render(txt)
  end

  def asset_url(src)
    return src unless ENV["RACK_ENV"] == "production"
    "http://#{Settings.assets_domain}/#{release_name}#{src}"
  end

  private

  def release_name
    @release_name ||= File.exists?(release_file_name) && File.read(release_file_name).strip
  end

  def release_file_name
    File.expand_path("RELEASE_NAME")
  end
end
