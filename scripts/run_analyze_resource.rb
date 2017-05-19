#encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + "/../utils/utils")
include XUnityDeploy::Logger

analyze = XUnityDeploy::AnalyzeResource.new
analyze.run