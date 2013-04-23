class App < Sinatra::Base
  not_found { erb :not_found }

  helpers Helpers

  use Rack::Session::Cookie,
      :key    => Settings.cookie_key,
      :secret => Settings.cookie_secret,
      :domain => Settings.cookie_domain unless test?

  register Sinatra::Flash
end
