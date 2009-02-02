=begin
 
  Capistrano Task Library > capistrano_svn_tags.rb
  Created by Anil Bawa <anil@quotesque.net>
  Distributed Under the BSD license
  
  + Task library to provide subversion tag support to Capistrano.
  
  - place this file somewhere in your rails app (i suggest lib/tasks)
  - add a 'require' statement in config/deploy.rb to load this file in
  - run 'rake remote:deploy_tag [tagname]' to deploy a tag (you can provide your own custom implementation of the task - edit it below)
  - tag rollbacks will work fine.
  - this library overrides a capistrano core method, so if you wish to use the default release type (latest revision, deployed as timestamp) then comment out the require.
  
=end

Capistrano.configuration(:must_exist).load do

  set :svn_tag_dir, 'tag' # new config var to denote the tag sub-directory in the svn repository  
  
  desc <<-DESC
  Update all servers with the provided tag of the source code. All this does
  is do a checkout of the provided svn tag (as defined by the svn module).
  DESC
  task :update_tag, :roles => [:app, :db, :web] do
  
    puts "  * deploying tag #{release}"

    on_rollback { delete release_path, :recursive => true }
    source.checkout_tag(self)
    run <<-CMD
      rm -rf #{release_path}/log #{release_path}/public/system &&
      ln -nfs #{shared_path}/log #{release_path}/log &&
      ln -nfs #{shared_path}/system #{release_path}/public/system
    CMD

  end

  desc <<-DESC
  Deploy svn tag, reset symlink and restart server.
  DESC
  task :deploy_tag, :roles => [:app, :db, :web] do

    set :release, ENV['TAG']
  
    unless release
      raise "please specify a tag to deploy!"
    end

    transaction do
      update_tag    
      symlink
      restart
    end
    
  end
  
end

module Capistrano

  #override a configuration object method to return the correct release_path for the tag.
  class Configuration
  
    # Return the full path to the named release. If a release is not specified,
    # the provided tag name (passed as a cli parameter) is used.
    def tag_path(tag_name = release)
      File.join(releases_path, tag_name)
    end
  
    alias_method :release_path, :tag_path
    
  end
  

  # add a method to the subversion object to checkout tags
  module SCM
  
    class Subversion
    
      # checkout a tag from a pre-configured svn tag dir.
      def checkout_tag(actor)
        op = configuration[:checkout] || "co"
        username = configuration[:svn_username] ? "--username #{configuration[:svn_username]}" : ""
        command = "#{svn} #{op} #{username} -q #{configuration.repository}/#{configuration.svn_tag_dir}/#{configuration.release} #{actor.release_path} &&"        
        run_checkout(actor, command, &svn_stream_handler(actor))         
      end
      
    end
  end
  
end
