application = 'test_authentication'
set :application, application
set :repo_url, 'https://github.com/tae1560/test_authentication.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/home/tae1560/apps/test_authentication'
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'
  after :finished, "deploy:unicorn_restart"

  %w[start stop restart].each do |command|
    puts "task unicorn_#{command}"
    desc "#{command} unicorn server"
    task "unicorn_#{command}" do

      on roles(:app) do
        execute "test -f /etc/init.d/unicorn_#{application} && /etc/init.d/unicorn_#{application} #{command} || echo file is not exist"

        if test "[ -f /etc/init.d/unicorn_#{application} ]"
          puts "file exist"
        else
          puts "file not exist"
        end
      end
    end
  end

  task :setup do
    invoke 'deploy'
    invoke 'deploy:setup_config'
    puts "setup"
  end

  task :setup_config do
    on roles(:app) do
      #execute "sudo ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
      #sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
      #sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
      execute "mkdir -p #{shared_path}/config"
      #put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
      execute "cp #{current_path}/config/database.example.yml #{shared_path}/config/database.yml"

      puts "Now edit the config files in x#{shared_path}."

      #invoke 'deploy:symlink_config'
      execute "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end
  end
  #after "deploy:setup", "deploy:setup_config"

  task :symlink_config do
    on roles(:app) do
      execute "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end
  end
  #after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:web) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

end
