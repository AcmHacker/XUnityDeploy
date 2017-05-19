#encoding = utf-8

# call anysdk command to build anysdk project
module XUnityDeploy
    class AnySDKCmd
        # TODO check unity environment
        def check
        end
        
        def build
            anysdk = "/Applications/AnySDK.app/Contents/MacOS/command"

            config_path = File.join(ConfigPath, "unity_deploy.json")
            config = JSON.parse (File.read_all(config_path))
            platform_config = config[DeployOptions[:platform].to_s]

            game_name = platform_config["ProductName"]
            channel = platform_config["Channel"]
            if DeployOptions[:platform] == :android then
                apk_file = "#{BuildPath}/android.apk"
                cmd = "#{anysdk} run -game '#{game_name}' -channel #{channel} -platform 0 -apkfile '#{apk_file}'"
            else
                ios_project_path = File.join(BuildPath, "ios", "Unity-iPhone.xcodeproj")
                cmd = "#{anysdk} run -game '#{game_name}' -channel #{channel} -platform 1 -projfile '#{ios_project_path}'"
            end
            raise "AnySDK build Error" unless cmd.sys_call_with_log
        end
    end
end