#encoding = utf-8
require 'fileutils'

module XUnityDeploy
    class ChannelCmd

        def run channel_name
            # check
            raise "the channel #{channel_name} is invalid" unless check(channel_name)

            # delete ConfigPath
            FileUtils.rm_rf(ConfigPath)

            # create ConfigPath
            Dir.mkdir(ConfigPath)

            # copy ChannelPath (channel config) to ConfigPath
            FileUtils.cp_r(File.join(ChannelPath, channel_name, "XUnityDeploy_configs"), UnityProjectPath)
        end

        private
        def check channel_name
            return channel_name != nil && Dir.exists?(File.join(ChannelPath, channel_name, "XUnityDeploy_configs"))
        end
    end
end
