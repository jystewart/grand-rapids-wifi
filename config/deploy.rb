set :application, "wifi"

set :scm, :git
set :repository,  "git@github.com:jystewart/grand-rapids-wifi.git"
set :branch, "master"

role :web, "grwifi.net"
role :app, "grwifi.net"
role :db, "grwifi.net", :primary => true

set :deploy_to, "/home/grwifi"

namespace :deploy do
  desc "Restart thin"
  task :restart, :roles => :web do
    "thin -C /etc/thin/wifi.thin restart"
  end
end

desc "Link in the production configuration"
task :link_config do
  run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
end

desc "After updating the code"
task :after_update, :roles => :app do
  link_config
end