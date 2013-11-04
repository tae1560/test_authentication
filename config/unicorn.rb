root = "/home/tae1560/apps/test_authentication/current"
working_directory root
pid "#{root}/tmp/pids/unicorn.pid"
stderr_path "#{root}/log/unicorn.log"
stdout_path "#{root}/log/unicorn.log"

listen "/tmp/unicorn.test_authentication.sock"
worker_processes 4
timeout 30