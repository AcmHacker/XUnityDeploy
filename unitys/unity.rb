#encoding = utf-8
module XUnityDeploy
    # compile base
    autoload :CompileBase, File.join(File.dirname(__FILE__), "compile_base")
    # compile unity
    autoload :CompileUnity, File.join(File.dirname(__FILE__), "compile_unity")
    # compile unity anysdk
    autoload :CompileUnityAnySDK, File.join(File.dirname(__FILE__), "compile_unity_anysdk")
    # analyze resource
    autoload :AnalyzeResource, File.join(File.dirname(__FILE__), "analyze_resource")
end