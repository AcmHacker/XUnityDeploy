#encoding = utf-8

module XUnityDeploy
    class SvnCmd
        
        def run
            Dir.chdir(UnityProjectPath)

            check 

            update

            status
        end

        private
        # check svn info
        def check
            cmd = "svn --version"
            raise "svn cmd not exist." unless cmd.sys_call

            cmd = "svn info"
            raise "svn or svn working copy is not exist." unless cmd.sys_call
        end

        # svn update
        def update            
            # # del files by svn status is ?
            # cmd = "svn st | grep '?' | awk '{print $2}' | grep ^Assets/ | xargs -I x rm -rf x"
            # raise 'remove ? error!' unless cmd.sys_call

            # svn up
            cmd = "svn up --accept 'theirs-full'"
            raise "svn up error!" unless cmd.sys_call
        end

        #svn status
        def status
            logger.info("**" * 10 + " svn list " + "**" * 10)            
            cmd = "svn st"
            raise "svn st error!" unless cmd.sys_call
        end        
    end
end    
