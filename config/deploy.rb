# config valid only for current version of Capistrano
lock '3.6.1'
require 'rvm/capistrano'
require 'bundler/capistrano'
set :application, 'gameday'
set :repo_url, 'git@github.com:JamesWojewoda/gameday.git'
set :user, 'ubuntu'
set :deploy_to, '/var/www/gameday'
set :branch, fetch(:branch, "master")
set :rvm_ruby_version, '2.3.0'
set :bundle_flags, '--deployment'
set :rails_env, fetch(:stage)

set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false  # Change to true if using ActiveRecord

## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
# Default value for :linked_files is []
set :linked_files, %w{config/secrets.yml}

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets','vendor/bundle', 'public/system', 'public/uploads')

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  # task :check_revision do
  #   on roles(:app) do
  #     unless `git rev-parse HEAD` == `git rev-parse origin/master`
  #       puts "WARNING: HEAD is not the same as origin/master"
  #       puts "Run `git push` to sync changes."
  #       exit
  #     end
  #   end
  # end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end
  # before :starting,     :check_revision
  # after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

