set :application, "wifi"

set :scm, :git
set :repository,  "git@github.com:jystewart/grand-rapids-wifi.git"
set :branch, "master"

role :web, "grwifi.net"
role :app, "grwifi.net"
role :db, "grwifi.net", :primary => true

set :deploy_to, "/home/grwifi"
#set :deploy_to, "/users/home/jystewart/web/wifi"

desc "Restart thin"
task :restart, :roles => :web do
  "thin -C /etc/thin/wifi.thin restart"
end

desc "Link in the production configuration"
task :link_config do
  run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
end

desc "Backup the database before we run any migrations, etc."
task :backup, :roles => :db, :only => { :primary => true } do
  # the on_rollback handler is only executed if this task is executed within
  # a transaction (see below), AND it or a subsequent task fails.
  on_rollback { delete "previous.sql" }
  db_file = YAML::load_file('config/database.yml')
  database = db_file['production']
  run "mysqldump -u #{database['user']} -p #{database['password']} -h #{database['host']} #{database['database']}> previous.sql"
end

desc "After updating the code"
task :after_update, :roles => :app do
  link_config
  backup
end