$LOAD_PATH.unshift File.expand_path('..', __FILE__)

require "app/boot"

map("/") { run BlogController }
map("/admin") { run AdminController }

unless ENV["RACK_ENV"] == "production"
  map("/assets") { run Assets::Environment.instance }
end

