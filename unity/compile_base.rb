#encoding = utf-8

module XUnityDeploy
    class CompileBase
        # version
        attr_accessor :version
        # platform(ios / android)
        attr_accessor :platform
        # channel
        attr_accessor :channel_id

        # TODO Subclass implementation
        def run
            compile_ios if DeployOptions[:platform] == :ios 
            compile_android if DeployOptions[:platform] == :android
        end

        protected
        # Subclass implementation
        def compile_android
        end

        # Subclass implementation
        def compile_ios
        end
    end
end
