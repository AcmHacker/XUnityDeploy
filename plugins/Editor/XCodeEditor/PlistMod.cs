using UnityEngine;
using UnityEditor;
using System.IO;
using System.Xml;
using System.Text;
using System.Collections;

namespace UnityEditor.XCodeEditor
{
    public class PlistMod
    {
        private static XmlNode FindPlistDictNode(XmlDocument doc)
        {
            XmlNode curr = doc.FirstChild;
            while(curr != null)
            {
                if(curr.Name.Equals("plist") && curr.ChildNodes.Count == 1)
                {
                    XmlNode dict = curr.FirstChild;
                    if(dict.Name.Equals("dict"))
                        return dict;
                }
                curr = curr.NextSibling;
            }
            return null;
        }
        
        private static XmlElement AddChildElement(XmlDocument doc, XmlNode parent, string elementName, string innerText=null)
        {
            XmlElement newElement = doc.CreateElement(elementName);
            if(innerText != null && innerText.Length > 0)
                newElement.InnerText = innerText;
            
            parent.AppendChild(newElement);
            return newElement;
        }
        
        public static void UpdatePlist(string xcodePath, string infoFile)
        {
            XCMod info = new XCMod(infoFile);
            UpdatePlist(xcodePath, info.DataStore);
        }

        /// <summary>
        /// update info 
        /// </summary>
        /// <param name="xcodePath"></param>
        /// <param name="data"></param>
        public static void UpdatePlist_Extend(string xcodePath, Hashtable data)
        {
            UpdatePlist(xcodePath, data);
        }

        //基础类型
        static void AddData(XmlDocument doc, XmlNode dict, Hashtable data, string key)
        {
            object value = data[key];

            //tim.add arraylist
            if (value is ArrayList)
            {
                XmlElement parent = doc.GetElementById(key);
                if (parent == null)
                {
                    AddChildElement(doc, dict, "key", key);
                    parent = AddChildElement(doc, dict, "array");
                }
                var values = data[key] as ArrayList;
                foreach (var item in values)
                {
                    AddChildElement(doc, parent, "string", item as string);
                }
                return;
            }

            //tim.add dic
            if (value is Hashtable)
            {
                AddChildElement(doc, dict, "key", key);
                var subDict = AddChildElement(doc, dict, "dict");
                Hashtable subData = value as Hashtable;
                foreach (string item in subData.Keys)
                {
                    AddData(doc, subDict, subData, item);
                }
                return;
            }
            //tim.add true, false
            //true, false
            if (value is bool)
            {
                Debug.Log(System.String.Format("info.update : key : {0}, value : {1}", key, value));
                AddChildElement(doc, dict, "key", key);
                AddChildElement(doc, dict, value.ToString().ToLower());
                return;
            }

            string type = "";
            if (value is string)
            {
                type = "string";
            }
            else if (value is int || value is double)
            {
                type = "integer";
            }
            else
            {
                Debug.LogError(System.String.Format("Info.plist Value {0} type {1} not defind!", value, value.GetType()));
            }
            if (type != "")
            {
                AddChildElement(doc, dict, "key", key);
                AddChildElement(doc, dict, type, value.ToString());
            }
        }
        static void UpdatePlist(string path, Hashtable data)
        {
            string fileName = "Info.plist";
            string fullPath = Path.Combine(path, fileName);
            
            XmlDocument doc = new XmlDocument();
            doc.Load(fullPath);
            
            if(doc == null)
            {
                Debug.LogError("Couldn't load " + fullPath);
                return;
            }
            
            XmlNode dict = FindPlistDictNode(doc);
            if(dict == null)
            {
                Debug.LogError("Error parsing " + fullPath);
                return;
            }
            
            foreach (string key in data.Keys)
            {
                if (key == "CFBundleURLTypes")
                {
                    XmlElement urlSchemeTop = doc.GetElementById("CFBundleURLTypes");
                    if (urlSchemeTop == null)
                    {
                        AddChildElement(doc, dict, "key", "CFBundleURLTypes");
                        urlSchemeTop = AddChildElement(doc, dict, "array");
                    }
                    var value = data[key] as ArrayList;
                    
                    foreach (Hashtable url in value)
                    {
                        XmlElement urlSchemeDict = AddChildElement(doc, urlSchemeTop, "dict");
                        {
                            AddChildElement(doc, urlSchemeDict, "key", "CFBundleURLName");
                            AddChildElement(doc, urlSchemeDict, "string", url["name"] as string);

                            AddChildElement(doc, urlSchemeDict, "key", "CFBundleURLSchemes");
                            XmlElement innerArray = AddChildElement(doc, urlSchemeDict, "array");
                            {
                                AddChildElement(doc, innerArray, "string", url["value"] as string);
                            }
                        }
                    }
                }
                else
                {
                    //NOTE.这里需要考虑value为dict的情况，若为dict，则应该递归的遍历
                    //object value = data[key];
                    AddData(doc, dict, data, key);
                }
            }
            
            //add the app id to the plist
            //the xml should end up looking like this
            /*
            <key>FacebookAppID</key>
            <string>YOUR_APP_ID</string>
             */
            //AddChildElement(doc, dict, "key", "FacebookAppID");
            //AddChildElement(doc, dict, "string", appId);
            
            
            //here's how the custom url scheme should end up looking
            /*
             <key>CFBundleURLTypes</key>
             <array>
                 <dict>
                     <key>CFBundleURLSchemes</key>
                     <array>
                         <string>fbYOUR_APP_ID</string>
                     </array>
                 </dict>
             </array>
            */
            /*XmlElement urlSchemeKey = */
            //AddChildElement(doc, dict, "key", "CFBundleURLTypes");
            //XmlElement urlSchemeTop = AddChildElement(doc, dict, "array");
            {
                //XmlElement urlSchemeDict = AddChildElement(doc, urlSchemeTop, "dict");
                {
                    /*XmlElement schemeKey = */
                    //AddChildElement(doc, urlSchemeDict, "key", "CFBundleURLSchemes");
                    
                    //XmlElement innerArray = AddChildElement(doc, urlSchemeDict, "array");
                    {
                        /*XmlElement finallyTheSValue = */
                        //AddChildElement(doc, innerArray, "string", "fb" + appId);
                    }
                }
            }
            
            
            doc.Save(fullPath);
            
            //the xml writer barfs writing out part of the plist header.
            //so we replace the part that it wrote incorrectly here
            System.IO.StreamReader reader = new System.IO.StreamReader(fullPath);
            string textPlist = reader.ReadToEnd();
            reader.Close();
            
            int fixupStart = textPlist.IndexOf("<!DOCTYPE plist PUBLIC");
            if(fixupStart <= 0)
                return;
            int fixupEnd = textPlist.IndexOf('>', fixupStart);
            if(fixupEnd <= 0)
                return;
            
            string fixedPlist = textPlist.Substring(0, fixupStart);
            fixedPlist += "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">";
            fixedPlist += textPlist.Substring(fixupEnd+1);
            
            System.IO.StreamWriter writer = new System.IO.StreamWriter(fullPath, false);
            writer.Write(fixedPlist);
            writer.Close();
        }
    }
}