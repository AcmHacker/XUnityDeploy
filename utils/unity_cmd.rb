#encoding = utf-8

# call unity command to build unity project
module XUnityDeloy
    class UnityCmd
        attr_access :project_path
        attr_access :method
        attr_access :log_path

        def initialize project_path, method, log_path
            super
            @project_path =  project_path
            @method = method
            @log_path = log_path
        end

        def build
            cmd = "/Applications/Unity/Unity.app/Contents/MacOS/Unity -batchmode -executeMethod #{@unity_method} -quit -logFile -projectPath #{@project_path} | tee #{@log_path}"
            cmd.sys_call
        end
    end
end