worker_processes 4
working_directory "/home/deploy/blog_app/current"

listen "/home/deploy/blog_app/shared/unicorn.sock", :backlog => 64
listen 3001, :tcp_nopush => true

timeout 30

pid "/home/deploy/blog_app/shared/pids/unicorn.pid"

stderr_path "/home/deploy/blog_app/shared/log/unicorn.stderr.log"
stdout_path "/home/deploy/blog_app/shared/log/unicorn.stdout.log"
