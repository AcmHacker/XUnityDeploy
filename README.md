XUnityDeploy是针对Unity自动化编译Android/IOS的脚本。

## 环境

* `Xcode` Version > 7.0

* `Ruby` Version > 2.0

* `Unity` Version > 5.0, 其中需要配置Android SDK，JDK, NDK等

* `Git` or `Svn`

* [`ios-deploy`][ios-deploy]

## 步骤

* 把`XUnityDeploy`放在`Assets`的同级目录

* 拷贝`plugins/Editor`到`Assets/Editor`

* 配置参数`XUnityDeploy_configs`下的`main.info.json`, `main.projmods.json`, `export.plist`, `unity_deploy.plist`
* `ruby scripts/run_unity.rb -p ios[android]`

## XUnityDeploy的流程图

1. 由`run_unity`启动脚本
2. `Ruby`脚本生成`Unity`需要的配置`unity_deploy`
3. `XUnityDeploy`读取`unity_deploy`配置，配置`Unity`项目，最后编译项目
4. `UnityDeployPostprocess`在编译`Unity`之后需要配置`Xcode`项目(IOS)

    * 读取`main.build`，获取`info`
    * 获取`projmods`，配置`Xcode`项目
    * 获取`info`, 配置`Xcode`的`Info.plist`

5. 对生成包进行重命名，并提交到down serve上

## Rake使用
* rake update 更新项目
* rake compile:ios 编译ios项目 
* rake compile:android 编译android项目
* rake install:ios 安装ios包
* rake install:android 安装android包
## 目录结构说明

* builds 最终生成包的目录(apk, xcode project, ipa)

* ../XUnityDeploy_configs 配置文件目录
    + `android.keystore` 是`Android`的签名文件，需要自己替换，并在`unity_deploy`中配置keystore
    + `export.plist` 是导出`ipa`包`xcode`需要的配置文件。其中`method`是`app-store`,`enterprise`, `ad-hoc`,`development`。参考[export.plist][export]

```text
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
		<key>compileBitcode</key>
		<false/>
        <key>method</key>
        <string>development</string>
</dict>
</plist>
``` 
+ `unity_deploy.json` 是`Unity`在`XUnityDeploy`中读取的配置，用于配置`Unity`的项目

```json
{
    "ios" :
    {
        "Version" : "1.0",
        "BundleVersionCode": 1,
        "BundleIdentifier" : "com.501joy.over14",
        "ProductName" : "XUnityDeploy",
        "IsDevelopment" : false,
        "DefineSymbols" : "EXAMPLE",
        "StrippingLevel" : "UseMicroMSCorlib",
        "ScriptCallOptimizationLevel" : "FastButNoExceptions",
        "IOSTargetOSVersion" : "7.0",
        "AotOptions" : "nimt-trampolines=256",
        "ScriptBackent" : "IL2CPP",
        "Channel" : "500026"
    },
    "android" :
    {
        "Version" : "1.0",
        "BundleVersionCode" : 1,
        "BundleIdentifier" : "com.501joy.over14",
        "ProductName" : "XUnityDeploy",
        "IsDevelopment" : false,
        "DefineSymbols" : "EXAMPLE",
        "StrippingLevel" : "UseMicroMSCorlib",
        "OBB" : false,
        "ScriptBackent" : "IL2CPP",
        "KeystoreName" : "android.keystore",
        "KeystorePass" : "example",
        "KeyaliasName" : "example",
        "KeyaliasPass" : "example",        
        "Channel" : "600001"
    }
}
```

* jenkins jenkins目录

* logs 编译日志目录 

* scripts 运行脚本命令目录

* tools 工具目录

* unitys 编译脚本目录

* utils 帮助脚本目录


## `说明`
* `executeMethod class 'XUnityDeploy' could not be found` 需要把`plugins/Editor`拷贝到`Assets/Editor`

* 这里关于`xcode`项目的配置在`Unity`的`XUnityDeploy`处理了，也就是配置`main.projmods.json`中的`build_settings`。这里还有一种方法在编译`Unity`之后，通过[Xcodeproj][url]配置`xcode`

* `Error Domain=IDEDistributionErrorDomain Code=1 "The operation couldn’t be completed` 修改`export.plist`。还碰到过`WWDR certificate expired`, 需要重新更新一下，[参考][wwdr]

* 因为`Unity`切换平台(ios/android)比较慢，所以这里建议针对ios/android单独checkout一个目录

* `Error Domain=IDEDistributionErrorDomain Code=14 "No applicable devices found."`。这里需要把`Ruby`版本设置为`system`，即使用`rvm use system` [参考][error_code14]

## TODO

* 检查编译环境的脚本

* 自动提交客户端的脚本

* 用`Xcodeproj`替代`Editor/XCodeEditor`

[url]: https://github.com/CocoaPods/Xcodeproj
[export]: http://www.matrixprojects.net/p/xcodebuild-export-options-plist/
[error_code14]: https://stackoverflow.com/questions/33901132/export-failed-error-using-xcodebuild-command-line-tool
[wwdr]: http://ajmccall.com/idedistributionerrordomain-code-1-error-and-fastlane/
[ios-deploy]: https://github.com/phonegap/ios-deploy
