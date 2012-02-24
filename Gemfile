source :rubygems

gem "rack", "1.4.1"
gem "sinatra", "1.3.2"
gem "sinatra-flash", "0.3.0", :require => "sinatra/flash"
gem "sass", "3.1.10"
gem "mongoid", "2.4.5"
gem "mongoid_slug", "0.8.3"
gem "bson_ext", "1.6.0"
gem "redcarpet", "1.17.2"
gem "unicorn", "4.2.0"

group :development do
  gem "capistrano", "2.11.2"
end

group :development, :test do
  gem "rake"
end

group :test do
  gem "rspec"
  gem "rack-test", :require => "rack/test"
  gem "simplecov", "0.6.0", :require => false
end
