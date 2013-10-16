class ApplicationController < Sinatra::Base
  not_found { erb :not_found }

  helpers ApplicationHelpers

  use Rack::Session::Cookie,
      :key    => Settings.cookie_key,
      :secret => Settings.cookie_secret,
      :domain => Settings.cookie_domain unless test?

  set :public_folder, "public"
  set :views, "app/views"

  register Sinatra::Flash
end
