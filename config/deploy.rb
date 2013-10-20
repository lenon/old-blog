require "bundler/capistrano"

set :application, "Blog"
set :scm, :git
# set :repository, "git@github.com:lenon/blog.git"
set :repository, "file:///Users/lenon/dev/blog"
set :deploy_to, "/home/blog/app"
set :deploy_via, :copy
set :copy_exclude, [".git/", ".gitignore", "README.md", "config/", "spec/", "Capfile", ".rspec"]
set :keep_releases, 1
set :use_sudo, false
set :normalize_asset_timestamps, false
set :shared_children, %w(config log tmp/pids tmp/sockets)
set :bundle_without, [:development, :test, :deployment]
set :git_shallow_clone, 1
set :assets_host, "assets.blog"
set :assets_user, "web"

role :app, "blog"

namespace :unicorn do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "/home/blog/app/current/scripts/unicorn/start"
  end
end

namespace :sass do
  task :precompile, :roles => :app, :except => { :no_release => true } do
    run "cd #{release_path} && bundle exec rake assets --trace"

    source      = "#{release_path}/public/assets/"
    destination = "#{assets_user}@#{assets_host}:/srv/public/assets/"

    run "rsync -az -e ssh \"#{source}\" \"#{destination}\""
    # run "rm #{release_path}/public/assets/*.*"
  end
end

after "deploy:update_code", "sass:precompile"
after "deploy:restart", "deploy:cleanup"
after "deploy:restart", "unicorn:restart"
