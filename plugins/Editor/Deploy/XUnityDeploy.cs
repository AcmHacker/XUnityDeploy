using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;
using System.Collections.Generic;
//using System.Threading;
using System;

public class XUnityDeploy
{
    public static string[] Levels
    {
        get
        {
            string[] scenes = new string[EditorBuildSettings.scenes.Length];
            for (int i = 0; i < EditorBuildSettings.scenes.Length; i++)
            {
                scenes[i] = EditorBuildSettings.scenes[i].path;
            }
            return scenes;
        }
    }
     
    //is Development mode
    static bool IsDevelopment
    {
        get;
        set;
    }
        
    static string UnityDeployConfigPath = "XUnityDeploy/configs/";

    /// <summary>
    /// get build path name of target
    /// </summary>
    /// <returns>The path name.</returns>
    /// <param name="target">Target.</param>
    static string BuildPathName(BuildTargetGroup target)
    {
        var path = "";
        string unityDeployBuildPath = "XUnityDeploy/builds";
        if (target == BuildTargetGroup.iOS)
        {
            path = System.IO.Path.Combine(Application.dataPath.Replace("Assets", ""), unityDeployBuildPath + "/ios");
        }
        else if (target == BuildTargetGroup.Android)
        {
            path = string.Format("./{0}/android.apk", unityDeployBuildPath);
        }
        return path;
    }

    //load deploy unity config
    static Hashtable LoadConfig(BuildTargetGroup target)
    {
        string unityCfg =  UnityDeployConfigPath +  "unity_deploy.json";

        var path = System.IO.Path.Combine(Application.dataPath.Replace("Assets", ""), unityCfg);

        var content = File.ReadAllText(path);
        var data = (Hashtable)XUPorterJSON.MiniJSON.jsonDecode(content);

        if (data == null)
        {
            throw new Exception("Read deploy unity error");
        }

        if (target == BuildTargetGroup.iOS)
        {
            return data["ios"] as Hashtable;
        }
        else
        {
            return data["android"] as Hashtable;
        }
    }

    //set unity version , symbols and others config
    static void UpdateUnityConfig(BuildTargetGroup target)
    {
        Hashtable config = LoadConfig(target);
        if (config != null)
        {
            var version = "Version";
            if (config.ContainsKey(version)) {
                PlayerSettings.bundleVersion = config[version].ToString();
            }

            var bundleId = "BundleIdentifier";
            if (config.ContainsKey(bundleId))
            {
                PlayerSettings.bundleIdentifier = config[bundleId].ToString();
            }

            //product name
            var productName = "ProductName";
            if (config.ContainsKey(productName))
            {
                PlayerSettings.productName = config[productName].ToString();
            }

            var isDevelop = "IsDevelopment";
            if (config.ContainsKey(isDevelop)) 
            {
                IsDevelopment = (bool)config[isDevelop];
            }

            var definesymbols = "DefineSymbols";
            if (config.ContainsKey(definesymbols))
            {
                PlayerSettings.SetScriptingDefineSymbolsForGroup(target, config[definesymbols].ToString());
            }

            //修改symlinklibraries 内容
            //现在IOS可以采用useMicroMSCorlib 这个属性了，之前听说protobuf不可以
            var strippingLevel = "StrippingLevel";
            if (config.ContainsKey(strippingLevel)) {
                // StrippingLevel.UseMicroMSCorlib;
                PlayerSettings.strippingLevel = (StrippingLevel)Enum.Parse(typeof(StrippingLevel), config[strippingLevel].ToString(), true);
            }

            //android
            if (target == BuildTargetGroup.Android)
            {
                //obb
                var obb = "OBB";
                if (config.ContainsKey(obb))
                {
                    PlayerSettings.Android.useAPKExpansionFiles = (bool)config[obb];
                }
                else
                {
                    PlayerSettings.Android.useAPKExpansionFiles = false;
                }

                //key store
                {                    
                    var keystoreName = "KeystoreName";
                    var keystorePass = "KeystorePass";
                    var keyaliasName = "KeyaliasName";
                    var keyaliasPass = "KeyaliasPass";

                    if (config.ContainsKey(keystoreName)) 
                    {
                        //"XUnityDelopy/config/Android_KeyStore/xx.keystore";
                        PlayerSettings.Android.keystoreName = UnityDeployConfigPath + config[keystoreName].ToString();
                    }
                    if (config.ContainsKey(keystorePass))
                    {
                        PlayerSettings.Android.keystorePass = config[keystorePass].ToString();
                    }
                    if (config.ContainsKey(keyaliasName))
                    {
                        PlayerSettings.Android.keyaliasName = config[keyaliasName].ToString();
                    }
                    if (config.ContainsKey(keyaliasPass))
                    {
                        PlayerSettings.keyaliasPass = config[keyaliasPass].ToString();
                    }
                }

                //android versionCode
                var bundleVersionCode = "BundleVersionCode";
                if (config.ContainsKey(bundleVersionCode))
                {
                    PlayerSettings.Android.bundleVersionCode = System.Convert.ToInt32(config[bundleVersionCode]);
                }
                Debug.Log("**** versionCode : " + PlayerSettings.Android.bundleVersionCode.ToString());
            }

            //ios 
            if (target == BuildTargetGroup.iOS) 
            {
                //采用fast no exception
                var scriptCallOptimization = "ScriptCallOptimizationLevel";
                if (config.ContainsKey(scriptCallOptimization)) {
                    // ScriptCallOptimizationLevel.FastButNoExceptions;
                    PlayerSettings.iOS.scriptCallOptimization = (ScriptCallOptimizationLevel)Enum.Parse(typeof(ScriptCallOptimizationLevel), config[scriptCallOptimization].ToString(), true);
                }

                //设置ios最低版本为ios7.0
                var targetOSVersion = "IOSTargetOSVersion";
                if (config.ContainsKey(targetOSVersion)) {
                    // iOSTargetOSVersion.iOS_7_0;
                    PlayerSettings.iOS.targetOSVersion = (iOSTargetOSVersion)Enum.Parse(typeof(iOSTargetOSVersion), config[targetOSVersion].ToString(), true);
                }
                    
                //修改AOT的参数,否则会出现Ran Out Of Trampolines of Type 2
                var aotOptions = "AotOptions";
                if (config.ContainsKey(aotOptions)) {
                    // "nimt-trampolines=256";   
                    PlayerSettings.aotOptions = config[aotOptions].ToString();
                }
            }
        }
        else
        {
            throw new Exception("Unity Deploy Config is Null");
        }
    }
                
    public static void BuildIOS()
    {
        UpdateUnityConfig(BuildTargetGroup.iOS);

        Debug.Log("**** Begin Deply IOS");

        if (!IsDevelopment)
        {
            BuildPipeline.BuildPlayer(Levels, 
                BuildPathName(BuildTargetGroup.iOS), 
                BuildTarget.iOS,
                BuildOptions.SymlinkLibraries);
        }
        else
        {
            BuildPipeline.BuildPlayer(Levels, 
                BuildPathName(BuildTargetGroup.iOS), 
                BuildTarget.iOS, 
                BuildOptions.SymlinkLibraries | BuildOptions.Development | BuildOptions.ConnectWithProfiler); 
        }
    }
        
    public static void BuildAndroid()
    {
        UpdateUnityConfig(BuildTargetGroup.Android);

        Debug.Log("**** Begin Deply Android");

        if (!IsDevelopment)
        {
            BuildPipeline.BuildPlayer(Levels, 
                BuildPathName(BuildTargetGroup.Android), 
                BuildTarget.Android, 
                BuildOptions.None);
        }
        else
        {
            BuildPipeline.BuildPlayer(Levels, 
                BuildPathName(BuildTargetGroup.Android), 
                BuildTarget.Android, 
                BuildOptions.Development);
        }
    }        
}