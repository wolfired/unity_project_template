using System;
using System.IO;

using UnityEngine;
using UnityEditor;
using Unity.CodeEditor;
using UnityEditor.SceneManagement;

namespace com.wolfired.dot_prj_stage1
{
    public class Lib { }

    public class CodeEditorHelper
    {
        public static void GenU3DProjectFiles()
        {
            CodeEditor.CurrentEditor.SyncAll();
            if (Application.isBatchMode)
            {
                EditorApplication.Exit(0);
            }
        }
    }

    public class UnityEditorHelper
    {
        public static void SetupAndroidSDKNDK()
        {
            var str_ndk = EditorPrefs.GetString("AndroidNdkRoot");
            if (null == str_ndk || "" == str_ndk || !Directory.Exists(str_ndk))
            {
                var env_str_ndk = Environment.GetEnvironmentVariable("ANDROID_NDK_ROOT");
                if (null == env_str_ndk || "" == env_str_ndk || !Directory.Exists(env_str_ndk))
                {
                    Debug.Log("请设置有效环境变量: ANDROID_NDK_ROOT");
                    return;
                }
                EditorPrefs.SetString("AndroidNdkRoot", env_str_ndk);
            }
            Debug.Log("AndroidNdkRoot: " + EditorPrefs.GetString("AndroidNdkRoot"));

            var str_sdk = EditorPrefs.GetString("AndroidSdkRoot");
            if (null == str_sdk || "" == str_sdk || !Directory.Exists(str_sdk))
            {
                var env_str_sdk = Environment.GetEnvironmentVariable("ANDROID_SDK_ROOT");
                if (null == env_str_sdk || "" == env_str_sdk || !Directory.Exists(env_str_sdk))
                {
                    Debug.Log("请设置有效环境变量: ANDROID_SDK_ROOT");
                    return;
                }
                EditorPrefs.SetString("AndroidSdkRoot", env_str_sdk);
            }
            Debug.Log("AndroidSdkRoot: " + EditorPrefs.GetString("AndroidSdkRoot"));

            if (Application.isBatchMode)
            {
                EditorApplication.Exit(0);
            }
        }

        public static void SetupVSCode()
        {
            if (Application.isBatchMode)
            {
                EditorApplication.Exit(0);
            }
        }

        public static void CreateDefaultScene()
        {
            var list = AssetDatabase.FindAssets("Default t:Scene", new[] { "Assets" });

            if (0 == list.Length)
            {
                var scene = EditorSceneManager.NewScene(NewSceneSetup.DefaultGameObjects, NewSceneMode.Single);
                EditorSceneManager.SaveScene(scene, "Assets/Default.unity");

                AssetDatabase.SaveAssets();
            }
            else
            {
                Debug.Log("Default Scene exits: " + list.Length);
            }

            if (Application.isBatchMode)
            {
                EditorApplication.Exit(0);
            }
        }
    }
}
