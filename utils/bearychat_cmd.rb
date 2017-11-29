#encoding = utf-8
require 'bearychat'

module XUnityDeploy
    class BearychatCmd
    
        def send msg
            incoming = Bearychat.incoming(get_hook_url)
            incoming.send({:text => msg})
        end

        def get_hook_url
            path = File.expand_path("~") + "/.unitydeploy.bearychat"
            raise "hook url = nil in #{path}" unless File.exists?(path)
            return File.read(path)
        end
    end
    
end