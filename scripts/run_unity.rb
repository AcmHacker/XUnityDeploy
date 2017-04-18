#encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + "/../utils/utils")
include XUnityDeploy::Logger

# svn = XUnityDeploy::SvnCmd.new
# svn.run

git = XUnityDeploy::GitCmd.new
git.run

compile = XUnityDeploy::CompileUnity.new
compile.run