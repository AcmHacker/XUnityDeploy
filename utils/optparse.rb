# encoding: utf-8
require 'optparse'

#untiy project path
UnityProjectPath = File.join(File.dirname(__FILE__), "../../")

#deploy unity path, 
DeployProjectPath = File.join(UnityProjectPath, "XUnityDeploy")

#deploy config file path
ConfigPath = File.join(DeployProjectPath, "config")

#deploy build path
BuildPath = File.join(DeployProjectPath, "build")

# deploy options
DeployOptions = {
    :platform => :ios,
    :client_mode => :develop,
    :channel_name => :official,
}

ARGV.clone.options do |opts|  
  opts.on("-p", "--platform=name", String,  
    "Specifies the client platform (ios/android).",
    "Default: ios"
  ) { |v| DeployOptions[:platform] = v }

  opts.on("-c", "--client_mode=mode", String,  
    "Specifies the client mode  (develop/business/publish).",
    "Default: develop"
  ) { |v| DeployOptions[:client_mode] = v }

  opts.separator ""  

  opts.on("-h", "--help", "Show this help message.") { puts opts; exit }  

  opts.parse!
end 

puts "Start XUnityDeloy Compile Unity  ..."
