require 'mongoid'
require 'mongoid_slug'
require 'r18n-core'
require 'settingslogic'
require 'sinatra/base'
require 'sinatra/flash'
require 'newrelic_rpm'

Mongoid.load!("config/mongoid.yml", ENV["RACK_ENV"])
Mongoid.raise_not_found_error = false
Mongoid.allow_dynamic_fields  = false

R18n.set 'pt-BR'

require 'lib/settings'
require 'lib/blog_settings'
require 'lib/helpers'
require 'lib/models/admin'
require 'lib/models/post'
require 'lib/app'
require 'lib/blog_app'
require 'lib/admin_app'
