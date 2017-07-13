#encoding = utf-8
require 'xcodeproj'

module XUnityDeploy
    class CompileUnityRenChang < CompileUnity

        protected
        def compile_android
            # copy firebase configs
            copy_firebase_configs

            super 
        end

        def compile_ios
            compile_ios_before

            compile_unity

            # support il8n
            # support_il8n

            #config 
            config_capabilities            

            # add Pods.xcodeproj
            add_pods_to_unity

            xcode = XUnityDeploy::XCodeCmd.new "Unity-iPhone.xcodeproj"
            xcode.run
        end

        def copy_firebase_configs
            script_path = File.join(DeployProjectPath, 'tools', 'Firebase', 'generate_xml_from_google_services_json.py')
            in_path = File.join(ConfigPath, 'firebase', 'google-services.json')
            out_path = File.join(UnityProjectPath, 'Assets', 'Plugins', 'Android', 'Firebase', 'res', 'values', 'googleservices.xml')

            cmd = "python #{script_path} -i #{in_path} -o #{out_path}"
            
            "copy firebase configs error" unless cmd.sys_call 
        end

        # add Pods.xcodeproj to unity
        def add_pods_to_unity 
            ios_project_path = File.join(BuildPath, "ios", "Unity-iPhone.xcodeproj")
            proj = ::Xcodeproj::Project.open(ios_project_path)

            pods_project_path = File.join(BuildPath, "ios", "Pods", "Pods.xcodeproj")
            proj.new_file(pods_project_path)

            proj.save
        end

        def config_capabilities
            proj_path = File.join(BuildPath, "ios", "Unity-iPhone.xcodeproj")
            config_path = File.join(ConfigPath, "ios", "main.build.json")

            config = JSON.parse (File.read_all(config_path))

            config['projmods'].each do |item|
                projmod_path = File.join(ConfigPath, "ios", item)
                projmods = JSON.parse(File.read_all(projmod_path))

                capabilities = projmods['system_capabilities']

                if capabilities then
                    system_capabilities(proj_path, capabilities)
                end
            end
            
        end
    end
end
