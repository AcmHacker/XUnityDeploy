# encoding: utf-8
require 'optparse'

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
    ) do |v| 
        raise "platform param '#{v}' error." unless [:ios, :android].include?(v.to_sym)
        DeployOptions[:platform] = v.to_sym 
    end

    opts.on("-c", "--client_mode=mode", String,  
        "Specifies the client mode  (develop/business/publish).",
        "Default: develop"
    ) do |v| 
        raise "client_mode param '#{v}' error." unless [:develop, :business, :publish].include?(v.to_sym)
        DeployOptions[:client_mode] = v 
    end

    opts.separator ""  

    opts.on("-h", "--help", "Show this help message.") { puts opts; exit }  

    opts.parse!
end

puts "Start XUnityDeploy Compile ..."
