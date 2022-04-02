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
}
