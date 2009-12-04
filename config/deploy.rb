set :application, "grwifi"

set :scm, :git
set :repository,  "git@github.com:jystewart/grand-rapids-wifi.git"
set :branch, "master"

role :web, "jystewart.vm.bytemark.co.uk"
role :app, "jystewart.vm.bytemark.co.uk"
role :db, "jystewart.vm.bytemark.co.uk", :primary => true

set :deploy_to, "/home/#{application}"
set :rails_env, "production"

namespace :deploy do
  desc "Restart passenger"
  task :restart, :roles => :web do
    "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :link do
  desc "Link in the production configuration"
  task :config do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

# add this to config/deploy.rb
namespace :delayed_job do
  desc "Start delayed_job process" 
  task :start, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job start" 
  end

  desc "Stop delayed_job process" 
  task :stop, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job stop" 
  end

  desc "Restart delayed_job process" 
  task :restart, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job restart" 
  end
end

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :sphinx do
  desc "Generate the ThinkingSphinx configuration file"
  task :configure do
    run "cd #{release_path} && RAILS_ENV=#{rails_env} rake thinking_sphinx:configure"
  end
  
  task :link_indices do
    run <<-CMD
      rm -fr #{release_path}/db/sphinx &&
      ln -nfs #{shared_path}/sphinx #{release_path}/db/sphinx
    CMD
  end
end

after 'deploy:update_code', "link:config"
after "deploy:update_code", "sphinx:link_indices"
after "deploy:update_code", "sphinx:configure"

after "deploy:start", "delayed_job:start" 
after "deploy:stop", "delayed_job:stop" 
after "deploy:restart", "delayed_job:restart"

