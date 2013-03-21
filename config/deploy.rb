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

set :server_ip, "198.211.115.249"

role :web, server_ip
role :app, server_ip
role :db,  server_ip, primary: true

namespace :unicorn do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "/home/blog/app/current/scripts/unicorn/start"
  end
end

after "deploy:restart", "deploy:cleanup"
after "deploy:restart", "unicorn:restart"