require File.expand_path(File.dirname(__FILE__) + "/../utils/utils")
include XUnityDeploy::Logger

compile = XUnityDeploy::ChannelCmd.new
compile.run ARGV.first
