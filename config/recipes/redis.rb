namespace :redis do
  desc "Install Redis"
  task :install, :roles => :app do
    run "#{sudo} add-apt-repository ppa:chris-lea/redis-server -y"
    run "#{sudo} apt-get -y -qq update"
    run "#{sudo} apt-get -y -qq install redis-server"
  end
  after "deploy:install", "redis:install"
end