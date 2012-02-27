worker_processes 2
working_directory "/home/deploy/blog_app/current"

listen "/home/deploy/blog_app/shared/unicorn.sock", :backlog => 10

timeout 30

pid "/home/deploy/blog_app/shared/pids/unicorn.pid"

stderr_path "/home/deploy/blog_app/shared/log/unicorn.stderr.log"
stdout_path "/home/deploy/blog_app/shared/log/unicorn.stdout.log"
