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
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

before 'deploy:migrate', "link_config"
before 'deploy:restart', "link_config"
