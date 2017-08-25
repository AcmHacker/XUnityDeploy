
task :update do
    desc "update unity project and deploy project"
    system ("git pull && cd .. && git pull")
end

namespace :compile do
    desc "compile unity ios"
    task :ios => :update do
        exec ("ruby scripts/run_unity.rb -p ios")
    end
    desc "compile unity ios with compile log"
    task :ios_with_log => :update do
        exec ("ruby scripts/run_unity.rb -p ios --is_log=true")
    end

    desc "compile unity android"
    task :android => :update do
        exec("ruby scripts/run_unity.rb -p android")
    end

    desc "compile unity android with compile log"
    task :android_with_log => :update do
        exec("ruby scripts/run_unity.rb -p android --is_log=true")
    end

    namespace :renchang do
        desc "compile renchang unity ios"
        task :ios => :update do
            exec ("ruby scripts/run_unity_renchang.rb -p ios --is_log=true")
        end

        desc "compile renchang unity android"
        task :android => :update do
            exec ("ruby scripts/run_unity_renchang.rb -p android --is_log=true")
        end
    end
end

namespace :install do 
    desc "install ios ipa"
    task :ios do
        exec ("ios-deploy --bundle ./builds/ios.ipa")
    end

    desc "install android apk"
    task :android do
        exec ("adb install -r ./builds/android.apk")
    end
end