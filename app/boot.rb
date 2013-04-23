require "mongoid"
require "mongoid_slug"
require "r18n-core"
require "settingslogic"
require "sinatra/base"
require "sinatra/flash"
require "newrelic_rpm"

Mongoid.load!("config/mongoid.yml", ENV["RACK_ENV"])
Mongoid.raise_not_found_error = false
Mongoid.allow_dynamic_fields  = false

R18n.set "pt-BR"

require "app/models/settings"
require "app/blog_settings"
require "app/helpers"
require "app/models/admin"
require "app/models/post"
require "app/app"
require "app/blog"
require "app/admin"
