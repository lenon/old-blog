require "lib/assets/sass_helpers"
require "lib/assets/environment"
require "lib/assets/manifest"

module Assets

  def self.compute_path(file)
    if ENV["RACK_ENV"] == "production"
      asset = Assets::Manifest.instance.assets[file]
    else
      asset = Assets::Environment.instance.find_asset(file).try(:digest_path)
    end

    unless asset
      raise "Missing asset: #{file}"
    end

    "/assets/#{asset}"
  end
end

