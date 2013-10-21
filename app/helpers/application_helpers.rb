module ApplicationHelpers
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
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true, :fenced_code_blocks => true)
    @markdown.render(txt)
  end

  def asset_url(path)
    asset = if production?
              Assets::Manifest.instance.assets[path] # from compiled manifest
            else
              Assets::Environment.instance.find_asset(path).try(:digest_path)
            end

    if asset
      "#{assets_domain_url}/assets/#{asset}"
    else
      raise "Missing asset: #{path}"
    end
  end

  private

  def production?
    ENV["RACK_ENV"] == "production"
  end

  def assets_domain_url
    if production? && Settings.assets_domain.present?
      "http://#{Settings.assets_domain}"
    else
      ""
    end
  end
end
