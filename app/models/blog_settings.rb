class BlogSettings
  def initialize(host)
    @host = host
  end

  def title       ; settings.title       ; end
  def description ; settings.description ; end
  def domain      ; settings.domain      ; end
  def home_title  ; settings.home_title  ; end
  def post_title  ; settings.post_title  ; end

  def self.from_cache(host)
    @settings       ||= {}
    @settings[host] ||= self.new(host)
  end

  private

  def settings
    @settings ||= (find_settings || default_settings)
  end

  def find_settings
    Settings.blogs.select { |b| b.domain == @host.to_s.downcase }.first
  end

  def default_settings
    Settings.blogs.first # first is the default
  end
end

