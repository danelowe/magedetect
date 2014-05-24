set :application, 'magedetect'
set :repo_url, 'git@github.com:danelowe/magedetect.git'
set :deploy_to, '/var/www/magedetect'
set :scm, :git
set :linked_files, %w{config/secrets.yml}
set :linked_dirs, %w{log tmp csvs}
set :sidekiq_log, File.join(current_path, 'log', 'sidekiq.log')
set :sidekiq_require, File.join(current_path, 'app', 'workers', 'sites_worker.rb')
set :deploy_via, :remote_cache
