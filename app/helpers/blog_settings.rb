class BlogSettings
  def initialize(host)
    @host = host
  end

  def title       ; settings.title       ; end
  def description ; settings.description ; end
  def domain      ; settings.domain      ; end
  def home_title  ; settings.home_title  ; end
  def post_title  ; settings.post_title  ; end

  private

  def settings
    @settings ||= (find_blog || Settings.blogs.first)
  end

  def find_blog
    Settings.blogs.reject { |b| b.domain != "#@host".downcase }.first
  end
end
