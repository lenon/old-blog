module Assets
  module SassHelpers

    def asset_path(path)
      parts = path.split(/(\?|\#)/)

      path  = parts.first
      query = parts[1..-1].join
      asset = environment.find_asset(path).digest_path

      "/assets/#{asset}#{query}"
    end
  end
end

