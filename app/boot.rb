require "mongoid"
require "mongoid_slug"
require "r18n-core"
require "settingslogic"
require "sinatra/base"
require "sinatra/flash"
require "newrelic_rpm"
require "redcarpet"

Mongoid.load!("config/mongoid.yml", ENV["RACK_ENV"])
Mongoid.raise_not_found_error = false
Mongoid.allow_dynamic_fields  = false

R18n.set "pt-BR"

require "app/assets"
require "app/helpers/blog_settings"
require "app/helpers/application_helpers"
require "app/models/admin"
require "app/models/post"
require "app/models/settings"
require "app/controllers/application_controller"
require "app/controllers/blog_controller"
require "app/controllers/admin_controller"

