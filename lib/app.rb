class App < Sinatra::Base
  not_found { erb :not_found }

  helpers Helpers

  use Rack::Session::Cookie, :secret => Settings.cookie_secret unless test?

  register Sinatra::Flash
end
