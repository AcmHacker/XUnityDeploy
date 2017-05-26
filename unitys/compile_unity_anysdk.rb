#encoding = utf-8
require 'xcodeproj'

module XUnityDeploy
    class CompileUnityAnySDK < CompileUnity

        protected
        def compile_android
            super 

            anysdk = AnySDKCmd.new 
            anysdk.build
        end

        def compile_ios
            compile_ios_before

            compile_unity

            # support il8n
            support_il8n
            
            remove_ios_target

            anysdk = AnySDKCmd.new 
            anysdk.build

            remove_ios_scheme

            xcode = XUnityDeploy::XCodeCmd.new "Unity-iPhone-#{channel}.xcodeproj"
            xcode.run
        end

        def remove_ios_target
            ios_project_path = File.join(BuildPath, "ios", "Unity-iPhone.xcodeproj")
            proj = ::Xcodeproj::Project.open(ios_project_path)
            targets = proj.targets
            if targets.length == 2 then
                logger.info("删除Test Target")
                targets[1].remove_from_project
                proj.save
            end
        end

        def remove_ios_scheme
            ios_project_path = File.join(BuildPath, "ios", "Unity-iPhone-#{channel}.xcodeproj")
            proj  = Xcodeproj::Project.open(ios_project_path)
            scheme = Xcodeproj::XCScheme.new(ios_project_path + '/xcshareddata/xcschemes/Unity-iPhone.xcscheme')
            scheme.add_build_target(proj.targets[0])
            scheme.save!
        end
    end
end
