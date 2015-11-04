# rake file to deploy application
# requires cf v5+
 
require "./environments"
require "pty"
require "expect"

# Make sure cf doesn't color the output so we can do clean regex of cf responses
# without having to look for unicode
ENV["CF_COLOR"] = "false"

environment = ENV["ENV"] || "au-syd-dev"
env = Environments.new
env.env = environment

api = ENV["CF_API"] || #{env.api}
space = ENV["CF_SPACE"] || #{env.space}
org = ENV["CF_ORG"] || #{env.org}

manifest = ENV["MANIFEST"] || "manifest.yml"
user = ENV["CF_USER"]
password = ENV["CF_PASSWD"]
host = ENV["APP_HOST"]

desc "Login to CF and set the api end point"
task :login do
  sh "cf api #{api}"
  loginCmd = "cf auth #{user}"
  puts "logging in..."
  puts "#{loginCmd} xxxx"
  
  #Use a pseudo terminal (PTY) to hide the password
  #Use expect to look for authentication and switching success
  #Make sure verbose is false so password is not logged to output
  $expect_verbose = false
  PTY.spawn(loginCmd + " #{password}") do |r,w,pid|
    match = r.expect(/(Authenticating.*\nOK)/, 30)
    puts match[1]
    puts    
  end
  sh "cf target -s #{env.space} -o #{env.org}"
end

desc "Clean the build target"
task :clean do
  require 'rake/clean'
  CLEAN.include("node_modules/")
end

desc "install package modules"
task :build do
  sh "bundle install"
end

desc "run unit tests"
task :unit_test => [:build] do
  
end

desc "Create services"
task :create_services => [:login] do
# cs_cmd = "cf create-service mongodb 100 mongo-rails-sample"
  cs_cmd = "cf cups mongo-rails-sample \
              -p '{\"host\": \"c425.candidate.54.mongolayer.com\", \"uri\": \"c425.candidate.54.mongolayer.com\", \
                   \"port\": 10425, \"db\": \"db\", \
                  \"username\": \"iwinoto\", \"password\": \"iwinoto\" }'"
  if (! (sh cs_cmd))
    puts "cf cups failed with exit status = #{$?.exitstatus}"
    if ($?.exitstatus != 60002)
      puts $?
      exit
    end
  end
end

desc "Create user provided service"
task :create_up_service => [:login] do
end

desc "Use cf to deploy to a cloudfoundry instance.
  Uses environment variables ENV and MANIFEST."
task :deploy => [:unit_test, :login] do
  cmd = "cf push"
  if (manifest)
    cmd += " -f #{manifest}"
  end
  if (host)
    cmd += " -n #{host}"
  end
  sh cmd
end
