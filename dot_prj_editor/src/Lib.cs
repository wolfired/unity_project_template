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

            AssemblyReloadEvents.afterAssemblyReload += () =>
            {
                Debug.Log("AssemblyReloadEvents.afterAssemblyReload");

                EditorSceneManager.OpenScene("Assets/Default");
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
