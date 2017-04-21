#encoding = utf-8

module XUnityDeploy
    class CompileBase
        # version
        attr_accessor :version
        # platform(ios / android)
        attr_accessor :platform
        # channel
        attr_accessor :channel_id

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
