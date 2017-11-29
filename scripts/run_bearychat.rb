#enconding: utf-8
require File.expand_path(File.dirname(__FILE__) + "/../utils/utils")
include XUnityDeploy::Logger

bearychat = XUnityDeploy::BearychatCmd.new
bearychat.send ARGV.first