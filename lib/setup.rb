require 'mongoid'
require 'mongoid_slug'
require 'r18n-core'

Encoding.default_external = 'utf-8'

Mongoid.logger = nil
Mongoid.raise_not_found_error = false
Mongoid.configure.from_hash({
  'database' => "app_blog_#{ENV['RACK_ENV']}"
})

R18n.set 'pt-BR'

require 'lib/models/admin'
require 'lib/models/post'
require 'lib/app'
require 'lib/blog_app'
require 'lib/admin_app'