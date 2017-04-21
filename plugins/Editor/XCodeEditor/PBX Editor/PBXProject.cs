using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace UnityEditor.XCodeEditor
{
	public class PBXProject : PBXObject
	{
		protected string MAINGROUP_KEY = "mainGroup";
        protected string TARGET_KEY = "targets";
		public PBXProject() : base() {
		}
		
		public PBXProject( string guid, PBXDictionary dictionary ) : base( guid, dictionary ) {
		}
		
		public string mainGroupID {
			get {
				return (string)_data[ MAINGROUP_KEY ];
			}
		}

        //Çå³ýUnity-iPhone Test Targets 
        public void cleanTargets()
        {
            var targetList = (PBXList)_data[TARGET_KEY];            
            if (targetList != null
                && targetList.Count > 1)
            {
                targetList.RemoveRange(1, targetList.Count - 1);
            }
        }
	}
}
