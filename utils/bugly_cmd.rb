#encoding = utf-8
require 'json'
require 'plist'

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
            info_plist =  Plist.parse_xml(File.join(BuildPath, "ios.xcarchive", "Info.plist"))
            info_property = info_plist["ApplicationProperties"]

            
            # deploy_config = JSON.parse(File.read(File.join(ConfigPath, "unity_deploy.json")))
            # main_version = deploy_config["ios"]["Version"]
            # build_version = File.read(File.join(UnityProjectPath, "Assets", "Resources", "info.txt"))
            # version = main_version + "." + build_version
            version = info_property["CFBundleShortVersionString"] + "." + info_property["CFBundleVersion"]
            package_name  = info_property["CFBundleIdentifier"]

            bugly_config = JSON.parse(File.read(File.join(ConfigPath, "bugly.json")))

            cmd = "java -jar #{bugly} -i #{dysm_path} -u -id #{bugly_config["appId"]} -key #{bugly_config["appKey"]} -package #{package_name} -version #{version}"
            # puts cmd
            cmd.sys_call_with_log
        end

    end
end