#encoding = utf-8

module XUnityDeploy
    class CompileBase
        # game name
        attr_accessor :game_name
        # channel
        attr_accessor :channel
        def initialize
            config_path = File.join(ConfigPath, "unity_deploy.json")
            config = JSON.parse (File.read_all(config_path))
            platform_config = config[DeployOptions[:platform].to_s]

            @game_name = platform_config["ProductName"]
            @channel = platform_config["Channel"]             
        end

        # Subclass implementation
        def run
            logger.info("Start Compile Unity Project(#{DeployOptions[:platform]}) ...")

            init_compile_config

            compile_ios if DeployOptions[:platform] == :ios 

            compile_android if DeployOptions[:platform] == :android
        end

        protected
        # Set compile config in client
        def init_compile_config
        end
        
        # Subclass implementation
        def compile_android
        end

        # Subclass implementation
        def compile_ios
        end
    end
end
