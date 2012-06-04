worker_processes 3
working_directory "/home/blog/blog/current"

listen "/home/blog/blog/shared/unicorn.sock", :backlog => 10

timeout 30

pid "/home/blog/blog/shared/unicorn.pid"

stderr_path "/home/blog/blog/shared/unicorn.stderr.log"
stdout_path "/home/blog/blog/shared/unicorn.stdout.log"
