source "https://rubygems.org/"

gem "rack", "1.5.2"
gem "sinatra", "1.4.2"
gem "sinatra-flash", "0.3.0"
gem "mongoid", "3.1.2"
gem "mongoid_slug", "3.0.0"
gem "redcarpet", "2.2.2"
gem "unicorn", "4.6.2"
gem "r18n-core", "1.1.4"
gem "newrelic_rpm", "3.6.0.78"
gem "settingslogic", "2.0.9"

group :assets do
  gem "uglifier", "~> 2.2.1"  
  gem "therubyracer"
  gem "sass", "3.2.7"
  gem "sprockets", "2.10.0"
end

group :deployment do
  gem "capistrano", "2.14.2"
end

group :development, :test do
  gem "rake"
end

group :test do
  gem "rspec"
  gem "rack-test", :require => "rack/test"
  gem "simplecov", "0.7.1", :require => false
  gem "factory_girl"
end
