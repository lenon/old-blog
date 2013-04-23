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
set :assets_host, "192.81.213.243"
set :assets_user, "web"

role :app, "198.211.115.249"

namespace :unicorn do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "/home/blog/app/current/scripts/unicorn/start"
  end
end

namespace :sass do
  task :precompile, :roles => :app, :except => { :no_release => true } do
    run "cd #{latest_release} && bundle exec sass --trace -t compressed --update app/assets/stylesheets/sass:app/assets/stylesheets"
    run "rm #{latest_release}/app/assets/stylesheets/sass/*.scss"

    source = "#{latest_release}/app/assets/"
    destination = "#{assets_user}@#{assets_host}:/srv/public/blog/#{release_name}/"

    run "rsync -az -e ssh \"#{source}\" \"#{destination}\""
    run "echo #{release_name} > #{latest_release}/RELEASE_NAME"
  end
end

after "deploy:update_code", "sass:precompile"
after "deploy:restart", "deploy:cleanup"
after "deploy:restart", "unicorn:restart"
