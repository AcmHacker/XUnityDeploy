#encoding = utf-8

module XUnityDeploy
    class GitCmd

        def run
            check

            # pull

            status
        end

        private
        def check
            cmd = "git --version"
            raise "git cmd not exist." unless cmd.sys_call

            cmd = "git status"
            raise "git repository not exist" unless cmd.sys_call
        end

        def pull
            cmd = "git pull"
            raise "git pull error" unless cmd.sys_call
        end

        def status
            logger.info("**" * 10 + " git list " + "**" * 10)
            cmd = "git status"
            raise "git status error" unless cmd.sys_call_with_log
        end
    end
end    
