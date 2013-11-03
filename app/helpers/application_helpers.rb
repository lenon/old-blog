module ApplicationHelpers
  include Rack::Utils
  include R18n::Helpers

  alias_method :h, :escape_html

  def current_user
    (session[:admin_id] && Admin.find(session[:admin_id])) || false
  end

  def blog_title ;       cached_settings.title ; end
  def blog_description ; cached_settings.description ; end
  def blog_domain ;      cached_settings.domain ; end

  def page_title
    if @title.present?
      cached_settings.post_title % @title
    else
      cached_settings.home_title
    end
  end

  def print_markdown(txt)
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true, :fenced_code_blocks => true)
    @markdown.render(txt)
  end

  def asset_url(file)
    asset = if production?
              compute_production_url(file)
            else
              compute_development_url(file)
            end

    if asset
      "#{assets_domain}/assets/#{asset}"
    else
      raise "Missing asset: #{file}"
    end
  end

  private

  def cached_settings
    host = request.env["HTTP_HOST"]
    host = nil if host == "localhost"
    BlogSettings.from_cache(host)
  end

  def production?
    ENV["RACK_ENV"] == "production"
  end

  def compute_production_url(file)
    Assets::Manifest.instance.assets[file] # from compiled manifest
  end

  def compute_development_url(file)
    Assets::Environment.instance.find_asset(file).try(:digest_path)
  end

  def assets_domain
    if production?
      "http://#{Settings.assets_domain}"
    else
      ""
    end
  end
end

