
# require 3rd lib
require 'yaml'

# require XUnityDeploy Scripts
require File.expand_path(File.dirname(__FILE__) + "/../utils/exception")

module XUnityDeploy
    module Utils
        extend self

        # 加载配置文件
        def load_config name
            # path = File.expand_path(File.dirname(__FILE__) + "/../config/" + name + ".yml")
            path = File.join(DeployConfig, name + ".yml")
            return YAML::load(File.open(path))
        end
    end    
end