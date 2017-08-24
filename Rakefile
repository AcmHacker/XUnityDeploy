
task :update do
    desc "update unity project and deploy project"
    exec ("git pull && cd .. && git pull")
end

namespace :compile do
    desc "compile unity ios"
    task :ios do
        exec ("ruby scripts/run_unity.rb -p ios")
    end

    desc "compile unity android"
    task :android do
        exec("ruby scripts/run_unity.rb -p android")
    end
end

namespace :compile_renchang do
    desc "compile renchang unity ios"
    task :ios do
        exec ("ruby scripts/run_unity_renchang.rb -p ios")
    end

    desc "compile renchang unity android"
    task :android do
        exec ("ruby scripts/run_unity_renchang.rb -p android")
    end
end

namespace :install do 
    desc "install ios ipa"
    task :ios do
        exec ("ios-deploy --bundle ./builds/ios.ipa")
    end

    desc "install android apk"
    task :android do
        exec ("android-install ./builds/android.apk")
    end
end