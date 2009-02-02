set :application, "wifi"
#ssh_options[:username] = 'jystewart'
set :svn_user, "deploy"
set :svn_password, Proc.new { Capistrano::CLI.password_prompt("SVN Password for #{svn_user}: ") }
set :repository,
  Proc.new { "--username #{svn_user} " +
             "--password #{svn_password} " +
             "http://projects.jystewart.net/svn/#{application}/trunk" }

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :web, "grwifi.net"
role :app, "grwifi.net"
role :db, "grwifi.net", :primary => true

set :deploy_to, "/home/grwifi"
#set :deploy_to, "/users/home/jystewart/web/wifi"

desc "Restart thin"
task :restart, :roles => :web do
  "thin -C /etc/thin/wifi.thin restart"
end

desc "Configure the database"
task :configure_database, :roles => :app do
  set :production_database_password, proc { Capistrano::CLI.password_prompt("Production database remote Password : ") }
  
  db_file = YAML::load_file('config/database.yml.template')
  # get ride of uneeded configurations
  db_file.delete('test')
  db_file.delete('development')

  # Populate production element
  db_file['production']['adapter'] = "mysql"
  db_file['production']['database'] = "wifi_production"
  db_file['production']['username'] = "jystewart"
  db_file['production']['password'] = production_database_password
  db_file['production']['host'] = "localhost"
  
  put YAML::dump(db_file), "#{release_path}/config/database.yml", :mode => 0664
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
  configure_database
  backup
end