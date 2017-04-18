#encoding = utf-8

module XUnityDeploy
    class CompileUnity < CompileBase
        def initialize
            super
        end

        protected
        def compile_android
            logger.debug("compile android")
        end

        def compile_ios
            logger.debug("compile ios")
        end

        def compile_unity
            init_unity_config
            
        end

        # generate unity config file and use them in compile unity
        def init_unity_config
            # TODO
        end
    end
end
