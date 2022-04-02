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
                Debug.Log("AssemblyReloadEvents.afterAssemblyReloadd");
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

    public class PreBuild
    {
        public static void SetupBooter()
        {
            Debug.Log("SetupBooter Begin");
            EditorSceneManager.OpenScene("Assets/Default.unity");

            var go = GameObject.Find("Main Camera");
            if (null != go)
            {
                Booter booter = null;
                if (!go.TryGetComponent<Booter>(out booter))
                {
                    go.AddComponent<Booter>();
                }
            }

            EditorSceneManager.SaveOpenScenes();
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
            Debug.Log("SetupBooter End");
        }
    }
}
