$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, '1.9.3@blog_app'
set :rvm_type, :user

load 'deploy'

default_run_options[:pty] = true

set :repository, "git://github.com/lenon/blog.git"
set :scm, :git
set :user, "deploy"
set :domain, ENV["BLOG_APP_DOMAIN"]
set :application, "blog_app"
set :port, ENV["BLOG_APP_SSH_PORT"]
set :use_sudo, false
set :branch, "master"
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :remote, user
set :scm_verbose, true
set :copy_cache, true
set :keep_releases, 3

role :web, domain
role :app, domain

namespace :deploy do
  task :start, :roles => [:web, :app] do
    run "cd #{current_path} && bundle install --without development test && bundle exec unicorn -c unicorn.conf.rb -E production -D"
  end

  task :stop, :roles => [:web, :app] do
    run "if [ -f /home/deploy/blog_app/shared/pids/unicorn.pid ]; then kill -s QUIT `cat /home/deploy/blog_app/shared/pids/unicorn.pid`; fi"
  end

  task :restart, :roles => [:web, :app] do
    stop
    start
  end

  task :cold do
    update
    start
  end

  task :finalize_update do
  end
end
