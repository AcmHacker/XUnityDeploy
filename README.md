XUnityDeploy是针对Unity自动化编译Android/IOS的脚本。

## XUnityDeploy的流程图

1. 由`run_xx`启动脚本
2. `Ruby`脚本生成`Unity`需要的配置`unity_deploy`
3. `XUnityDeploy`读取`unity_deploy`配置，配置`Unity`项目，最后编译项目
4. `UnityDeployPostprocess`在编译`Unity`之后需要配置`Xcode`项目(IOS)

    * 读取`main.build`，获取`info`
    * 获取`projmods`，配置`Xcode`项目
    * 获取`info`, 配置`Xcode`的`Info.plist`

5. 对生成包进行重命名，并提交到down serve上

## 目录结构说明

* builds 最终生成包的目录(apk, xcode project, ipa)

* configs 配置文件目录

    + `unity_deploy.json` 是`Unity`在`XUnityDeploy`中读取的配置，用于配置`Unity`的项目
    + `android.keystore` 是`Android`的签名文件，需要自己替换，并在`unity_deploy`中配置keystore

* jenkins jenkins目录

* logs 编译日志目录 

* scripts 运行脚本命令目录

* tools 工具目录

* unitys 编译脚本目录

* utils 帮助脚本目录



