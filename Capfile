set :rvm_ruby_string, '1.9.3@blog'

require "rvm/capistrano"
require "bundler/capistrano"

load "deploy"

default_run_options[:pty] = true

set :application, "blog"
set :repository, "git://github.com/lenon/blog.git"
set :scm, :git
set :user, "blog"
set :domain, "lenonmarcel.com.br"
set :port, 3299
set :use_sudo, false
set :branch, "master"
set :deploy_to, "/home/blog/blog"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :remote, user
set :scm_verbose, true
set :copy_cache, true
set :keep_releases, 3

server "lenonmarcel.com.br", :app

namespace :deploy do
  task :start do
    run "rm #{current_path}/newrelic.yml"
    run "cp #{shared_path}/newrelic.yml #{current_path}/newrelic.yml"
    run "cd #{current_path} && bundle exec unicorn -c unicorn.conf.rb -E production -D"
  end

  task :stop do
    run "if [ -f /home/blog/blog/shared/unicorn.pid ]; then kill `cat /home/blog/blog/shared/unicorn.pid`; fi"
  end

  task :restart do
    stop
    start
  end
end

before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
