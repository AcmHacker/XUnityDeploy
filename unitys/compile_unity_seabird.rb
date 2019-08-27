#encoding = utf-8

module XUnityDeploy
    class CompileUnitySeaBird
        # ignore super
        def initialize
            raise "pls set target." if DeployOptions[:target] == ""
        end

        def run
            logger.info("Start Compile Unity (#{DeployOptions[:target]}) ...")

            # rm xcode
            if DeployOptions[:target].include?("IOS") then
                xcode_path = File.join(UnityProjectPath, "builds", "xcode")
                FileUtils.remove_entry(xcode_path, true)
            end

            do_compile
        end        

        private
        def do_compile
            cmd = UnityCmd.new "XUnityDeploy.#{DeployOptions[:target]}"
            raise "*** Compile #{DeployOptions[:target]} failed!" unless cmd.build
        end
        
    end
end