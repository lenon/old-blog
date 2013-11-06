module ApplicationHelpers
  include Rack::Utils
  include R18n::Helpers

  alias_method :h, :escape_html

  # Returns the current Admin or false if no admin is logged in.
  def current_user
    if session[:admin_id]
      Admin.find(session[:admin_id])
    else
      false
    end
  end

  # Returns the title (or name) of the current blog.
  def blog_title
    cached_settings.title
  end

  # Returns the description of current blog.
  def blog_description
    cached_settings.description
  end

  # Returns the domain of current blog.
  def blog_domain
    cached_settings.domain
  end

  # Returns the formated title for the current page.
  # If @title is set, blog's post_title setting is used. Otherwise,
  # home_title is returned.
  def page_title
    if @title.present?
      cached_settings.post_title % @title
    else
      cached_settings.home_title
    end
  end

  # Converts a string formated in markdown to html.
  def print_markdown(txt)
    Markdown::Processor.instance.render(txt)
  end

  # Returns the asset url for a given file.
  # If the current environment is production returns the complete URL
  # to the asset using blog's assets_domain setting. Otherwise,
  # returns the path to the given asset.
  def asset_url(file)
    asset = if production?
              compute_production_url(file)
            else
              compute_development_url(file)
            end

    unless asset
      raise "Missing asset: #{file}"
    end

    "#{assets_domain}/assets/#{asset}"
  end

  private

  def cached_settings
    BlogSettings.from_cache(request.env["HTTP_HOST"])
  end

  def production?
    ENV["RACK_ENV"] == "production"
  end

  def compute_production_url(file)
    Assets::Manifest.instance.assets[file]
  end

  def compute_development_url(file)
    Assets::Environment.instance.find_asset(file).try(:digest_path)
  end

  def assets_domain
    if production?
      "http://#{Settings.assets_domain}"
    end
  end
end

