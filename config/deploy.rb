set :application, "grwifi"

set :scm, :git
set :repository,  "git@github.com:jystewart/grand-rapids-wifi.git"
set :branch, "master"

role :web, "jystewart.vm.bytemark.co.uk"
role :app, "jystewart.vm.bytemark.co.uk"
role :db, "jystewart.vm.bytemark.co.uk", :primary => true

set :deploy_to, "/home/#{application}"

namespace :deploy do
  desc "Restart passenger"
  task :restart, :roles => :web do
    "touch #{current_path}/tmp/restart.txt"
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