using System;
using UnityEditor;
using UnityEngine;
using com.wolfired.dot_prj_core;
using UnityEditor.SceneManagement;

namespace com.wolfired.dot_prj_editor
{
    public class Lib { }

    [InitializeOnLoad]
    public class InitializeOnX
    {
        static InitializeOnX()
        {
            AssemblyReloadEvents.beforeAssemblyReload += () =>
            {
                Debug.Log("AssemblyReloadEvents.beforeAssemblyReload");
            };

            Debug.Log("InitializeOnLoad");

            AssemblyReloadEvents.afterAssemblyReload += () =>
            {
                Debug.Log("AssemblyReloadEvents.afterAssemblyReload");

                var ss = new[] { new SceneSetup() };
                ss[0].isLoaded = true;
                ss[0].isActive = true;
                ss[0].isSubScene = false;
                ss[0].path = "Assets/Default.unity";
                EditorSceneManager.RestoreSceneManagerSetup(ss);

                var go = GameObject.Find("Main Camera");
                if (null != go)
                {
                    Booter booter = null;
                    if (!go.TryGetComponent<Booter>(out booter))
                    {
                        go.AddComponent<Booter>();

                        AssetDatabase.SaveAssets();
                        AssetDatabase.Refresh();
                    }
                }
            };
        }

        [InitializeOnLoadMethod]
        public static void InitializeOnLoadMethod()
        {
            Debug.Log("InitializeOnLoadMethod");
        }

        // [InitializeOnEnterPlayMode]
        // public static void InitializeOnEnterPlayMode(EnterPlayModeOptions options)
        // {
        //     Debug.Log("InitializeOnEnterPlayMode: " + options);
        // }
    }
}
