
task :update do
    desc "update unity project and deploy project"
    system ("git pull && cd .. && git pull")

    desc "update gitversion in Assets/Resources/info.txt"
    # use printf , not use echo
    system ("cd .. && printf $(git rev-list HEAD --abbrev-commit --max-count=1) > Assets/Resources/info.txt")
end

namespace :compile do
    desc "compile unity ios"
    task :ios => :update do
        system ("ruby scripts/run_unity.rb -p ios")
    end
    desc "compile unity ios with compile log"
    task :ios_with_log => :update do
        system ("ruby scripts/run_unity.rb -p ios --is_log=true")
    end

    desc "compile unity android"
    task :android => :update do
        system("ruby scripts/run_unity.rb -p android")
    end

    desc "compile unity android with compile log"
    task :android_with_log => :update do
        system("ruby scripts/run_unity.rb -p android --is_log=true")
    end

    namespace :renchang do
        desc "compile renchang unity ios"
        task :ios => :update do
            system ("ruby scripts/run_unity_renchang.rb -p ios --is_log=true")

            # system ("ruby scripts/run_bearychat.rb 'IOS端编译完成' ")
            Rake::Task["bearychat:send"].invoke("Build-IOS-Over")
            Rake::Task["bearychat:send"].reenable
        end

        desc "compile renchang unity android"
        task :android => :update do
            system ("ruby scripts/run_unity_renchang.rb -p android --is_log=true")

            # system ("ruby scripts/run_bearychat.rb 'Android端编译完成' ")
            Rake::Task["bearychat:send"].invoke("Build-Android-Over")
            Rake::Task["bearychat:send"].reenable
        end
    end
    
    namespace :seabird do
        desc "build seabrid unity project"
        task :build => :update do |t, args|
            system ("ruby scripts/run_unity_seabird.rb -t #{ENV['target']} --is_log=true")
        end
    end
end

namespace :fir do
    desc "fir publish ios"
    task :ios, [:msg] do |t, args|
        args.with_defaults(:msg => '版本更新')
        system ("fir publish ./builds/ios.ipa -c " + args[:msg])
    end

    desc "fir publish android"
    task :android, [:msg] do |t, args|
        args.with_defaults(:msg => '版本更新')
        system ("fir publish ./builds/android.apk -c " + args[:msg])
    end
end

namespace :bearychat do
    desc "send msg to  bearychat"
    task :send, [:msg] do |t, args|
        args.with_defaults(:msg => '空(nil)')
        system ("ruby scripts/run_bearychat.rb " + args[:msg])
    end
end

namespace :bugly do
    desc "update dsym file to bugly"
    task :upload do
        system ("ruby scripts/run_bugly.rb")
    end
end

namespace :auto do
    desc "auto compile renchang-unity ios"
    task :ios do
        Rake::Task["compile:renchang:ios"].invoke
        Rake::Task["fir:ios"].invoke
        Rake::Task["bugly:upload"].invoke
    end

    desc "auto compile renchang-unity android"
    task :android do
        Rake::Task["compile:renchang:android"].invoke
        Rake::Task["fir:android"].invoke
    end

    desc "auto compile renchang-unity ios & android"
    task :all do
        Rake::Task["auto:ios"].invoke
        Rake::Task["auto:android"].invoke
    end
end

namespace :install do 
    desc "install ios ipa"
    task :ios do
        system ("ios-deploy --bundle ./builds/ios.ipa")
    end

    desc "install android apk"
    task :android do
        system ("adb install -r ./builds/android.apk")
    end
end

# namespace :test do
#     task :test1 do        
#         Rake::Task["bearychat:send"].invoke("t1")
#         Rake::Task["bearychat:send"].reenable
#         Rake::Task["bearychat:send"].invoke("t2")
#     end

#     task :test2 do |t, args|
#         puts t
#         puts args
#     end

#     task :test3 do
#         Rake::Task["test:test2"].execute("test", "12")
#     end
# end