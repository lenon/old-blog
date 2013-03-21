require "bundler/capistrano"

set :application, "Blog"
set :user, "blog"
set :scm, :git
set :repository, "git@github.com:lenon/blog.git"
set :deploy_to, "/home/blog/app"
set :deploy_via, :copy
set :copy_exclude, [".git/", ".gitignore", "README.md", "config/", "spec/", "Capfile", ".rspec"]
set :keep_releases, 1
set :use_sudo, false
set :normalize_asset_timestamps, false
set :shared_children, %w(config log tmp/pids tmp/sockets)
set :bundle_without, [:development, :test, :deployment]
set :git_shallow_clone, 1

role :app, "198.211.115.249"

namespace :unicorn do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "/home/blog/app/current/scripts/unicorn/start"
  end
end

namespace :sass do
  task :precompile, :roles => :app, :except => { :no_release => true } do
    run "cd #{latest_release} && bundle exec sass --trace -t compressed --update lib/public/stylesheets/sass:lib/public/stylesheets"
    run "rm #{latest_release}/lib/public/stylesheets/sass/*.scss"
  end
end

after "deploy:update_code", "sass:precompile"
after "deploy:restart", "deploy:cleanup"
after "deploy:restart", "unicorn:restart"
