#encoding = utf-8

module XUnityDeploy
    class CompileUnity < CompileBase
        def initialize
            super
        end

        protected
        def compile_android
            compile_android_before

            compile_unity
        end

        def compile_ios
            compile_ios_before

            compile_unity

            xcode = XUnityDeploy::XCodeCmd.new "Unity-iPhone"
            xcode.run
        end

        def compile_unity
            cmd = UnityCmd.new get_unity_method

            raise "***Compile #{DeployOptions[:platform]} failed!" unless cmd.build
            # raise "***Scan Compile #{@platform} log error!" if scan_error?            
        end

        # do things before compile android
        # such as copy files or delete files
        def compile_android_before
            # TODO
        end

        def compile_ios_before
            # remove old project path
            path = File.join(BuildPath, "ios")
            FileUtils.remove_entry(path, true)

            path = File.join(BuildPath, "ios.xcarchive")
            FileUtils.remove_entry(path, true)
            
        end

        # generate unity config file and use them in compile unity
        def init_compile_config
            # TODO
        end

        def get_unity_method
           if DeployOptions[:platform] == :ios
               return "XUnityDeploy.BuildIOS"
            else
                return "XUnityDeploy.BuildAndroid"
            end
        end

        def system_capabilities proj_path, config_hash
            proj = ::Xcodeproj::Project.open(proj_path)
            uuid = proj.targets.first.uuid
            capabilities = proj.root_object.attributes['TargetAttributes'][uuid]['SystemCapabilities']

            config_hash.each do |key, value|
                if value then 
                    capabilities[key] = {"enabled" => "1"}
                else
                    capabilities[key] = {"enabled" => "0"}
                end
            end

            proj.save
        end
    end
end
