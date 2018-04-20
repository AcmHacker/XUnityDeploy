#encoding = utf-8
require 'json'

# call unity command to build unity project
module XUnityDeploy
    class BuglyCmd
        def initialize
        end

        # TODO check unity environment
        def check
        end
        
        def build
            project_path = UnityProjectPath
            bugly = File.join(ToolPath, "bugly", "buglySymboliOS.jar")
            dysm_path = File.join(BuildPath, "ios.xcarchive", "dSYMs", "cannon.app.dSYM")
            bugly_config = JSON.parse(File.read(File.join(ConfigPath, "bugly.json")))
            deploy_config = JSON.parse(File.read(File.join(ConfigPath, "unity_deploy.json")))
            main_version = deploy_config["ios"]["Version"]
            build_version = File.read(File.join(UnityProjectPath, "Assets", "Resources", "info.txt"))
            version = main_version + "." + build_version

            cmd = "java -jar #{bugly} -i #{dysm_path} -u -id #{bugly_config["appId"]} -key #{bugly_config["appKey"]} -package #{deploy_config["ios"]["BundleIdentifier"]} -version #{version}"
            # puts cmd
            cmd.sys_call_with_log
        end

    end
end