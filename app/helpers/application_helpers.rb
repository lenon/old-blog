module ApplicationHelpers
  include Rack::Utils

  alias_method :h, :escape_html

  # Returns the current Admin or false if no admin is logged in.
  def current_admin
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
    path = Assets.compute_path(file)
    "#{assets_domain}#{path}"
  end

  private

  def cached_settings
    BlogSettings.from_cache(request.env["HTTP_HOST"])
  end

  def assets_domain
    if ENV["RACK_ENV"] == "production"
      "http://#{Settings.assets_domain}"
    end
  end
end

