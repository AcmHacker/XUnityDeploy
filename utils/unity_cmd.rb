#encoding = utf-8

# call unity command to build unity project
module XUnityDeploy
    class UnityCmd
        def initialize method
            @method = method
        end

        def build
            project_path = UnityProjectPath
            unity = "/Applications/Unity/Unity.app/Contents/MacOS/Unity"
            if DeployOptions[:is_log] then
                log_path = File.join(LogPath, "deploy_#{DeployOptions[:platform]}.log")
                cmd = "#{unity} -batchmode -executeMethod #{@method} -quit -logFile -projectPath #{project_path} | tee #{log_path}"
            else
                cmd = "#{unity} -batchmode -executeMethod #{@method} -quit -logFile -projectPath #{project_path}"
            end
            cmd.sys_call_with_log
        end

        # TODO check unity environment
        def check
        end
    end
end