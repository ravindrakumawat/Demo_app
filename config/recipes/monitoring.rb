namespace :monitoring do
  desc "Install Some Monitoring Tools etc"
  task :install, :roles => :app do
    run "#{sudo} apt-get -y -qq install htop iotop logrotate"
  end
  after "deploy:install", "monitoring:install"

  task :setup_logrotate do
    template("logrotate.conf.erb","#{shared_path}/#{application}.logrotate.conf")
    run "mkdir -p #{shared_path}/log/old"
    run "#{sudo} cp #{shared_path}/#{application}.logrotate.conf /etc/logrotate.d"
  end
  after "deploy:setup", "monitoring:setup_logrotate"
end