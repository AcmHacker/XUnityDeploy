
# require 3rd lib
require 'yaml'
require 'json'

#untiy project path
UnityProjectPath = File.join(File.dirname(__FILE__), "../../")

#deploy unity path, 
DeployProjectPath = File.join(UnityProjectPath, "XUnityDeploy")

#deploy config file path
ConfigPath = File.join(DeployProjectPath, "configs")

#deploy build path
BuildPath = File.join(DeployProjectPath, "builds")

#deploy build path
LogPath = File.join(DeployProjectPath, "logs")

# require XUnityDeploy Scripts
require File.expand_path(File.join(DeployProjectPath, "utils/optparse"))
require File.expand_path(File.join(DeployProjectPath, "utils/logger"))
require File.expand_path(File.join(DeployProjectPath, "utils/file_extend"))
require File.expand_path(File.join(DeployProjectPath, "utils/string_extend"))
require File.expand_path(File.join(DeployProjectPath, "utils/unity_cmd"))
require File.expand_path(File.join(DeployProjectPath, "utils/xcode_cmd"))
require File.expand_path(File.join(DeployProjectPath, "utils/svn_cmd"))
require File.expand_path(File.join(DeployProjectPath, "utils/git_cmd"))

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
end