using System;
using UnityEngine;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.XCodeEditor;
using System.Collections.Generic;
using System.Collections;

using XUPorterJSON;
using System.IO;

namespace UnityEditor.XUnityDeploy
{
    public static class XUnityDeployPostProcess
    {
        delegate void AddData(Hashtable root, string key);

        [PostProcessBuild(200)]
        public static void OnPostProcessBuild(BuildTarget target, string path)
        {
            Debug.Log("XUnityDeploy Post Process ....");
            if (target == BuildTarget.iOS)
            {
                var project = new UnityEditor.XCodeEditor.XCProject(path);

                var xcodeConfigPath = Path.Combine(Application.dataPath.Replace("Assets", ""), "XUnityDeploy/configs/xcode");

                var buildFilePath = Path.Combine(xcodeConfigPath, "main.build.json");
                Debug.Log("buildPath : " + buildFilePath);
                string buildContent = System.IO.File.ReadAllText(buildFilePath);

                var buildData = MiniJSON.jsonDecode(buildContent) as Hashtable;
                var projmodList = buildData["projmods"] as ArrayList;

                // Find and run through all projmods files to patch the project
//                string projModPath = System.IO.Path.Combine(Application.dataPath, "Editor/iOS");
                var projModPath = xcodeConfigPath;
                for (int index = 0; index < projmodList.Count; ++index)
                {
                    var file = System.IO.Path.Combine(projModPath, projmodList[index].ToString());
					Debug.Log(String.Format("Project ApplyMode : {0}", file));
                    try
                    {
                        project.ApplyMod(file);
                    }
                    catch (System.Exception ex)
                    {
                        //log
                        Debug.LogError("Project ApplyMode Exception : " + ex.Message + ex.StackTrace);
                        throw ex;
                    }

                }                    

                project.Save();

                var info = buildData["info"] as string;
                var infoPath = System.IO.Path.Combine(projModPath, info);
                var infoContent = System.IO.File.ReadAllText(infoPath);
                var infoData = MiniJSON.jsonDecode(infoContent) as Hashtable;

                PlistMod.UpdatePlist_Extend(path, infoData);
            }

            if (target == BuildTarget.Android)
            {
                //TODO
            }
        }
    }
}
