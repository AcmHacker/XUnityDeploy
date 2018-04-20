
# require 3rd lib
require 'yaml'
require 'json'
require 'fileutils'
require 'pathname'

#untiy project path
UnityProjectPath = Pathname.new(File.dirname(__FILE__)).join("../../").cleanpath

#deploy unity path, 
DeployProjectPath = File.join(UnityProjectPath, "XUnityDeploy")

#deploy config file path
ConfigPath = File.join(UnityProjectPath, "XUnityDeploy_configs")

#deploy build path
BuildPath = File.join(DeployProjectPath, "builds")

#deploy logs path
LogPath = File.join(DeployProjectPath, "logs")

#deploy tools path
ToolPath = File.join(DeployProjectPath, "tools")

# require XUnityDeploy Scripts
require File.expand_path(File.join(DeployProjectPath, "utils/optparse"))
require File.expand_path(File.join(DeployProjectPath, "utils/logger"))
require File.expand_path(File.join(DeployProjectPath, "utils/file_extend"))
require File.expand_path(File.join(DeployProjectPath, "utils/string_extend"))
require File.expand_path(File.join(DeployProjectPath, "utils/unity_cmd"))
require File.expand_path(File.join(DeployProjectPath, "utils/xcode_cmd"))
require File.expand_path(File.join(DeployProjectPath, "utils/svn_cmd"))
require File.expand_path(File.join(DeployProjectPath, "utils/git_cmd"))
require File.expand_path(File.join(DeployProjectPath, "utils/anysdk_cmd"))
require File.expand_path(File.join(DeployProjectPath, "utils/bearychat_cmd"))
require File.expand_path(File.join(DeployProjectPath, "utils/bugly_cmd"))

require File.expand_path(File.join(DeployProjectPath, "unitys/unity"))

module XUnityDeploy
    module Utils
        extend self

        # load config yml files
        def load_config name
            path = File.join(DeployConfig, name + ".yml")
            return YAML::load(File.open(path))
        end
    end 

    def version
        "1.0"
    end   
end