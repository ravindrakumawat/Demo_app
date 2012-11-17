set :application, "demo_app"
set :repository,  "git://github.com/ravindrakumawat/Demo_app.git"
set :user, "root"
set :ssh_options, { :forward_agent => true }
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "50.116.45.116"                          # Your HTTP server, Apache/etc
role :app, "50.116.45.116"                          # This may be the same as your `Web` server
role :db,  "50.116.45.116", :primary => true # This is where Rails migrations will run

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
set :timezone, "Asia/Kolkata"
set :whenever_command, "bundle exec whenever"
set :whenever_environment, defer { rails_env }
set :setup_ssl, true
set :ssl_cert, "final.crt"
set :ssl_cert_key, "site.key"
set :is_default, false

set :deploy_to, "/home/#{user}/apps"
set :branch, "master"

load 'config/recipes/base'
load 'config/recipes/security'
load 'config/recipes/nodejs'
load 'config/recipes/memcached'
load 'config/recipes/imagemagick'
load 'config/recipes/redis'
load 'config/recipes/check'
load 'config/recipes/unicorn'
load 'config/recipes/nginx'
load 'config/recipes/ruby_installer'
load 'config/recipes/postfix'
load 'config/recipes/mysql'

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

#If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end