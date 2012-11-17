namespace :memcached do
  desc "Install Memcached"
  task :install, :roles => :app do
    run "#{sudo} apt-get -y -qq install memcached"
  end
  after "deploy:install", "memcached:install"

  desc "restart"
  task :restart, :roles => :app do
    run "#{sudo} service memcache restart"
  end

  desc "flush the cache"
  task :flush, :roles => :app do
    run "echo 'flush_all' | nc localhost 11211"
  end
  after "deploy:create_symlink", "memcached:flush"
end