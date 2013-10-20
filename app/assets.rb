require "sprockets"

Assets = Sprockets::Environment.new
Assets.append_path "app/assets/javascripts"
Assets.append_path "app/assets/stylesheets"
Assets.append_path "app/assets/fonts"

Assets.context_class.class_eval do
  def asset_path(path)
    split = path.split(/(\?|\#)/)

    path  = split.first
    query = split[1..-1].join
    asset = environment.find_asset(path).digest_path

    "/assets/#{asset}#{query}"
  end
end

if ENV["RACK_ENV"] == "production"
  AssetsManifest = Sprockets::Manifest.new("public/assets/manifest.json")
end

