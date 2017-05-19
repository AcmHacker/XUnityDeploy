#encoding = utf-8

module XUnityDeploy
    class AnalyzeResource
        
        def run
            resources = read_resources            

            analyze_resources(resources)
        end        

        private
        def read_resources
            resources = []
            File.open("#{LogPath}/deploy_#{DeployOptions[:platform].to_s}.log").each do |line|
                if /% Assets/ =~ line then
                    path = line.sub(/\n/, '').split(/ /)[4..-1].join(' ')
                    resources << path
                end                
            end
            resources
        end

        def analyze_resources resources
            # clear
            FileUtils.remove_entry("#{LogPath}/Assets", true)
            Dir::mkdir "#{LogPath}/Assets"

            resources.each do |path|
                begin
                    copy_files path
                rescue Errno::ENOENT
                    logger.error("copy #{path} failed")
                end
            end            
        end

        def copy_files path
            source_path = File.join(UnityProjectPath, path)
            index = path.rindex('/')
            path = "#{LogPath}/#{path[0..index]}"
            FileUtils.mkdir_p path
            FileUtils.cp_r source_path, path                                  
        end
        
    end
end    