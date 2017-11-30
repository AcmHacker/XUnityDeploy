# encoding: utf-8
require 'optparse'

# deploy options
DeployOptions = {
    :platform => :ios,
    # :client_mode => :develop,
    :channel_name => :official,
    :is_log => false,
}

ARGV.clone.options do |opts|  
    # platform
    opts.on("-p", "--platform=name", String,  
        "Specifies the client platform (ios/android).",
        "Default: ios"
    ) do |v| 
        raise "platform param '#{v}' error." unless [:ios, :android].include?(v.to_sym)
        DeployOptions[:platform] = v.to_sym 
    end

    #client mode
    # opts.on("-c", "--client_mode=mode", String,  
    #     "Specifies the client mode  (develop/business/publish).",
    #     "Default: develop"
    # ) do |v| 
    #     raise "client_mode param '#{v}' error." unless [:develop, :business, :publish].include?(v.to_sym)
    #     DeployOptions[:client_mode] = v 
    # end

    #is log
    opts.on("-l", "--is_log=open", TrueClass,
        "open or close log to configs/ (true/false).",
        "Default: false"
    ) do |v| 
        DeployOptions[:is_log] = v 
    end

    opts.separator ""  

    opts.on("-h", "--help", "Show this help message.") do
        puts opts
        exit 
    end

    opts.parse!
end

puts "Start XUnityDeploy ..."
