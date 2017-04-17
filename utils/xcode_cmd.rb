#encoding = utf-8

module XUnityDeloy
    class XcodeCmd
        attr_access :project_name
        attr_access :root_path

        attr_access :xcode_version

        def initialize project_name
            @project_name = project_name
            @xarchive_path = File.join(BuildPath, "ios.xcharchive")
            @ipa_path = File.join(BuildPath, "ios.ipa")
            @xcode_plist_path = File.join(ConfigPath, "xcode.plist")

            @xcode_sign_identify = ""

            @xcode_version = xcode_version
        end

        def build

        end 

        private
        def remove_old_files
            "rm -rf #{}".sys_call

            "rm -rf #{@ipa_path}".sys_call
        end       

        def xcode_version
            version = "xcodebuild -version | grep 'Xcode' | awk '{print $2}'".sys_call_with_result
        end

        def xcode6?
            @xcode_version.start_with?('6.')
        end

        def xcode7?
            @xcode_version.start_with?('7.')
        end

        def xcode8?
            @xcode_version.start_with?('8.')
        end

        def sign_ipa
            profile_name = "todo"

            if xcode6? 
                cmd = "xcodebuild -exportArchive -exportFormat ipa -archivepath #{@xarchive_path} -exportPath #{@ipa_path} -exportProvisioningProfile #{@profile_name}"
            else
                cmd = "xcodebuild -exportArchive -archivePath #{@xarchive_path} -exportPath #{@project_path} -exportOptionsPlist #{xcode_plist_path}"
            end

            if not xcode6?
                cmd = "mv #{@project_path}/Unity-iPhone.ipa #{@ipa_path}"
                raise "mv ipa error!" unless cmd.sys_call
            end
        end

    end
end

