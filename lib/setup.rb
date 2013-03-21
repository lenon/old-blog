require 'mongoid'
require 'mongoid_slug'
require 'r18n-core'

Mongoid.load!("config/mongoid.yml", ENV["RACK_ENV"])
Mongoid.raise_not_found_error = false

R18n.set 'pt-BR'

require 'lib/models/admin'
require 'lib/models/post'
require 'lib/app'
require 'lib/blog_app'
require 'lib/admin_app'