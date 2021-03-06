#encoding = utf-8

module XUnityDeploy
    class XCodeCmd

        def initialize project_name
            # xcworkspace or xcodeproj directory is exist
            if (File.directory?(File.join(BuildPath, "ios", project_name + ".xcworkspace"))) 
                project_name = project_name + ".xcworkspace"
            else 
                project_name = project_name + ".xcodeproj"
            end
            @project_path = File.join(BuildPath, "ios", project_name)
            @xarchive_path = File.join(BuildPath, "ios.xcarchive")
            @ipa_path = File.join(BuildPath, "ios.ipa")
            @export_plist = File.join(ConfigPath, "export.plist")

            config_path = File.join(ConfigPath, "ios", "main.projmods.json")
            config = JSON.parse (File.read_all(config_path))
            @xcode_sign_identify = config['build_settings']['CODE_SIGN_IDENTITY']

            @xcodebuild_safe = File.join(ToolPath, "bash", "xcodebuild-safe.sh")

            # add sign
            unlock_cmd = unlock_keychain_cmd
            @xcodebuild_safe = unlock_cmd + " & " + @xcodebuild_safe if !unlock_cmd.empty?
        end

        def run
            # build xcode
            build

            #sign ipa
            sign
        end 

        private
        def build
            # remove old files

            FileUtils.remove_entry(@xarchive_path, true)
            FileUtils.remove_entry(@ipa_path, true)

            # cmd = "#{@xcodebuild_safe} -project #{@project_path} -scheme 'Unity-iPhone' archive -archivePath #{@xarchive_path}"                        
            cmd = ""
            # workspace
            if (@project_path.end_with?(".xcworkspace")) then
                cmd = "#{@xcodebuild_safe} -workspace #{@project_path} -scheme 'Unity-iPhone' archive -archivePath #{@xarchive_path}"
            else
                # project
                cmd = "#{@xcodebuild_safe} -project #{@project_path} -scheme 'Unity-iPhone' archive -archivePath #{@xarchive_path}"
            end

            if cmd.sys_call_with_log or File.exist?(@xarchive_path) then
                logger.info("xcode build ok.")
            else
                raise "xcode build error"
            end
        end       

        def sign
            ipa_dir_path = BuildPath
            cmd = "#{@xcodebuild_safe} -exportArchive -archivePath #{@xarchive_path} -exportPath #{ipa_dir_path} -exportOptionsPlist #{@export_plist}"
            raise "xcodebuild export error!" unless cmd.sys_call_with_log

            #rename
            File.rename(File.join(ipa_dir_path, ipa_name), @ipa_path)
        end

        def ipa_name
            env = {}
            env = YAML.load_file(EnvPath) if File.exist? EnvPath
            name = env["ipa_name"] || "Unity-iPhone.ipa"
            return name
        end

        def unlock_keychain_cmd
            env = {}
            env = YAML.load_file(EnvPath) if File.exist? EnvPath
            passwd = env["system_passwd"] || ""
            if passwd.empty? then
                return ""
            else 
                return "security unlock-keychain -p '#{passwd}' ~/Library/Keychains/login.keychain"
            end
        end

        def xcode_version
            version = "xcodebuild -version | grep 'Xcode' | awk '{print $2}'".sys_call_with_result
        end     

        # TODO check xcode environment
        def check
            
        end         
    end
end

