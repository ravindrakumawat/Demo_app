def template(from, to, options = {})
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to, options
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def close_sessions # method is needed when changing user from root to deployer. Sessions need to close
  sessions.values.each { |session| session.close }
  sessions.clear
end

def kill_processes_matching(name,signal = 1)
  run "ps -ef | grep #{name} | grep -v grep | awk '{print $2}' | xargs kill -#{signal} || echo 'no process with name #{name} found'"
end

set_default(:application_hostname) { Capistrano::CLI.ui.ask "Application Hostname: " }
set_default(:application_hostfqdn) { Capistrano::CLI.ui.ask "Application Fully Qualified Domain Name: " }

namespace :deploy do

  desc "Install everything onto the server"
  task :install do
    run "#{sudo} apt-get -y -qq update"
    run "#{sudo} apt-get -y -qq install python-software-properties wget vim less curl git-core"
    run "#{sudo} add-apt-repository ppa:brightbox/ruby-ng-experimental -y"
    run "#{sudo} add-apt-repository ppa:chris-lea/node.js -y"
    run "#{sudo} apt-get -y -qq update"
    #run "#{sudo} dpkg-reconfigure locales"
    #run "#{sudo} update-locale LANG=en_US.UTF-8"
    run "echo '#{timezone}' | #{sudo} tee /etc/timezone"
    run "#{sudo} dpkg-reconfigure --frontend noninteractive tzdata"
  end

  desc "Set Hostname"
  task :set_hostname do
    run "#{sudo} hostname #{application_hostname}"
    run "echo '#{application_hostname}' | #{sudo} tee /etc/hostname"
    template "hosts.erb", "/tmp/hosts"
    run "sed -i {s/IPADDRESS/`ifconfig eth0 | grep 'inet addr:'| cut -d: -f2 | awk '{ print $1}'`/} /tmp/hosts"
    run "#{sudo} mv /tmp/hosts /etc/hosts"
    run "#{sudo} start hostname"
  end
  after "deploy:install", "deploy:set_hostname"

end