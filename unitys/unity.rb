#encoding = utf-8
module XUnityDeploy
    # compile base
    autoload :CompileBase, File.join(File.dirname(__FILE__), "compile_base")
    # compile unity
    autoload :CompileUnity, File.join(File.dirname(__FILE__), "compile_unity")
    # compile unity anysdk
    autoload :CompileUnityAnySDK, File.join(File.dirname(__FILE__), "compile_unity_anysdk")

    # compile unity ren chang
    autoload :CompileUnityRenChang, File.join(File.dirname(__FILE__), "compile_unity_renchang")
    
    # compile unity sea brid
    autoload :CompileUnitySeaBird, File.join(File.dirname(__FILE__), "compile_unity_seabird")

    # analyze resource
    autoload :AnalyzeResource, File.join(File.dirname(__FILE__), "analyze_resource")
end