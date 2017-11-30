#encoding = utf-8
# require 'bearychat'
require 'bearychat-notifier'

module XUnityDeploy
    class BearychatCmd
    
        def send msg
            if hook_url_exist? then
                # incoming = Bearychat.incoming(get_hook_url)
                # incoming.send({:text => msg})

                Bearychat::Notifier.new(get_hook_url).ping(msg)
            else 
                logger.warn("hook_url not exist.")
            end
        end

        def get_hook_url
            # path = File.expand_path("~") + "/.unitydeploy.bearychat"
            # raise "hook url = nil in #{path}" unless File.exists?(path)
            return File.read(get_hook_path).strip
        end

        def hook_url_exist?
            return File.exists?(get_hook_path)
        end

        def get_hook_path
            return File.expand_path("~") + "/.unitydeploy.bearychat"
        end
    end
    
end