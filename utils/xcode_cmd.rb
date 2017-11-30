#encoding = utf-8

module XUnityDeploy
    class XCodeCmd

        def initialize project_name
            @project_path = File.join(BuildPath, "ios", project_name)
            @xarchive_path = File.join(BuildPath, "ios.xcarchive")
            @ipa_path = File.join(BuildPath, "ios.ipa")
            @export_plist = File.join(ConfigPath, "export.plist")

            config_path = File.join(ConfigPath, "ios", "main.projmods.json")
            config = JSON.parse (File.read_all(config_path))
            @xcode_sign_identify = config['build_settings']['CODE_SIGN_IDENTITY']

            @xcodebuild_safe = File.join(ToolPath, "bash", "xcodebuild-safe.sh")
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

            cmd = "#{@xcodebuild_safe} -project #{@project_path} -scheme 'Unity-iPhone' archive -archivePath #{@xarchive_path}"
            # cmd = "xcodebuild -project #{@project_path} -scheme 'Unity-iPhone' archive"

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
            File.rename(File.join(ipa_dir_path, "Unity-iPhone.ipa"), @ipa_path)
        end

        def xcode_version
            version = "xcodebuild -version | grep 'Xcode' | awk '{print $2}'".sys_call_with_result
        end     

        # TODO check xcode environment
        def check
            
        end         
    end
end

