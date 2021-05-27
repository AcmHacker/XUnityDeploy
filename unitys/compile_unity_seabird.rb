#encoding = utf-8

module XUnityDeploy
    class CompileUnitySeaBird
        # ignore super
        def initialize
            raise "pls set target." if DeployOptions[:target] == ""

            if build_ios? then
                DeployOptions[:platform] = :ios
            else
                DeployOptions[:platform] = :android
            end
        end

        def run
            logger.info("Start Compile Unity (#{DeployOptions[:target]}) ...")

            # rm xcode
            if build_ios? then
                xcode_path = File.join(UnityProjectPath, "builds", "xcode")
                FileUtils.remove_entry(xcode_path, true)

                ipa_path = File.join(UnityProjectPath, "builds", "IPA")
                FileUtils.remove_entry(ipa_path, true)
            else
                # rm apk
                apk_path = File.join(UnityProjectPath, "builds", "*.apk")
                Dir[apk_path].each {|filename| FileUtils.remove_file(filename, true) }
                aab_path = File.join(UnityProjectPath, "builds", "*.aab")
                Dir[aab_path].each {|filename| FileUtils.remove_file(filename, true) }
            end

            do_compile

            # ios build xcode
            if build_ios? then
                do_compile_xcode
            end
        end        
        
        # private
        def build_ios?
            return DeployOptions[:target].include?("IOS")
        end

        def do_compile
            cmd = UnityCmd.new "XUnityDeploy.#{DeployOptions[:target]}"
            raise "*** Compile #{DeployOptions[:target]} failed!" unless cmd.build
        end
        
        def do_compile_xcode
            shell_path = File.join(ToolPath, "bash", "create_ipa.sh")
            xcode_path = File.join(UnityProjectPath, "builds", "xcode")
            plist_path = File.join(UnityProjectPath, "configs", "packagePList.plist")
            xcarchive_path = File.join(UnityProjectPath, "builds", "xcode", "ship.xcarchive")
            ipa_path = File.join(UnityProjectPath, "builds", "IPA")
            cmd = "/bin/bash #{shell_path} #{xcode_path} #{plist_path} #{xcarchive_path} #{ipa_path}"
            raise "*** Compile Xcode error" unless cmd.sys_call_with_log
        end
    end
end