namespace :imagemagick do
  desc "Install Imagemagick"
  task :install, :roles => :app do
    run "#{sudo} apt-get -y -qq install imagemagick libxslt-dev libxml2-dev"
  end
  after "deploy:install", "imagemagick:install"
end