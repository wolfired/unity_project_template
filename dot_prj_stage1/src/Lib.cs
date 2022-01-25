using System;
using System.IO;

using Mono.Options;

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
            var exit_code = 0;

            var prefs_key_ndk_root = "AndroidNdkRoot";
            var prefs_val_ndk_root = "";
            if (EditorPrefs.HasKey(prefs_key_ndk_root))
            {
                prefs_val_ndk_root = EditorPrefs.GetString(prefs_key_ndk_root);
            }

            if (null == prefs_val_ndk_root || "" == prefs_val_ndk_root || !Directory.Exists(prefs_val_ndk_root))
            {
                prefs_val_ndk_root = Environment.GetEnvironmentVariable("ANDROID_NDK_ROOT");
                if (null == prefs_val_ndk_root || "" == prefs_val_ndk_root || !Directory.Exists(prefs_val_ndk_root))
                {
                    prefs_val_ndk_root = Environment.GetEnvironmentVariable("ANDROID_NDK_HOME");
                    if (null == prefs_val_ndk_root || "" == prefs_val_ndk_root || !Directory.Exists(prefs_val_ndk_root))
                    {
                        Debug.Log("You Need Setup Env Var: ANDROID_NDK_ROOT");
                        exit_code = 1;
                    }
                    else
                    {
                        EditorPrefs.SetString(prefs_key_ndk_root, prefs_val_ndk_root);
                    }
                }
                else
                {
                    EditorPrefs.SetString(prefs_key_ndk_root, prefs_val_ndk_root);
                }
            }
            Debug.Log("AndroidNdkRoot: " + prefs_val_ndk_root);

            var prefs_key_sdk_root = "AndroidSdkRoot";
            var prefs_val_sdk_root = "";
            if (EditorPrefs.HasKey(prefs_key_sdk_root))
            {
                prefs_val_sdk_root = EditorPrefs.GetString(prefs_key_sdk_root);
            }

            if (null == prefs_val_sdk_root || "" == prefs_val_sdk_root || !Directory.Exists(prefs_val_sdk_root))
            {
                prefs_val_sdk_root = Environment.GetEnvironmentVariable("ANDROID_SDK_ROOT");
                if (null == prefs_val_sdk_root || "" == prefs_val_sdk_root || !Directory.Exists(prefs_val_sdk_root))
                {
                    Debug.Log("You Need Setup Env Var: ANDROID_SDK_ROOT");
                    exit_code = 1;
                }
                else
                {
                    EditorPrefs.SetString(prefs_key_sdk_root, prefs_val_sdk_root);
                }
            }
            Debug.Log("AndroidSdkRoot: " + prefs_val_sdk_root);
        }

        public static void SetupVSCode()
        {
            var exit_code = 0;

            var prefs_key_vscode_cmd = "kScriptsDefaultApp";
            var prefs_val_vscode_cmd = "";
            if (EditorPrefs.HasKey(prefs_key_vscode_cmd))
            {
                prefs_val_vscode_cmd = EditorPrefs.GetString(prefs_key_vscode_cmd);
            }
            if (null == prefs_val_vscode_cmd || "" == prefs_val_vscode_cmd || !File.Exists(prefs_val_vscode_cmd))
            {
                prefs_val_vscode_cmd = Environment.GetEnvironmentVariable("VSCODE_CMD");
                if (null == prefs_val_vscode_cmd || "" == prefs_val_vscode_cmd || !File.Exists(prefs_val_vscode_cmd))
                {
                    Debug.Log("You Need Setup Env Var: VSCODE_CMD");
                    exit_code = 1;
                }
                else
                {
                    EditorPrefs.SetString(prefs_key_vscode_cmd, prefs_val_vscode_cmd);
                }
            }
            Debug.Log("VSCode CMD: " + prefs_val_vscode_cmd);


            var prefs_key_vscode_args = "vscode_arguments";
            var prefs_val_vscode_args = "";
            if (EditorPrefs.HasKey(prefs_key_vscode_args))
            {
                prefs_val_vscode_args = EditorPrefs.GetString(prefs_key_vscode_args);
            }
            if (null == prefs_val_vscode_args || "" == prefs_val_vscode_args)
            {
                prefs_val_vscode_args = "\"$(ProjectPath)\" -g \"$(File)\":$(Line):$(Column)";
                EditorPrefs.SetString(prefs_key_vscode_args, prefs_val_vscode_args);
            }
            Debug.Log("VSCode Arguments: " + prefs_val_vscode_args);

            if (Application.isBatchMode)
            {
                EditorApplication.Exit(exit_code);
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

    public class DefaultAndroidBuilder
    {
        public static void Build()
        {
            UnityEditorHelper.SetupAndroidSDKNDK();

            var outfile = "";
            var optionSet = new OptionSet{
                    {"builder_args_outfile=", "unity build out file", v => outfile = v},
                };
            optionSet.Parse(System.Environment.GetCommandLineArgs());

            BuildPlayerOptions buildPlayerOptions = new BuildPlayerOptions();
            buildPlayerOptions.scenes = new[] { "Assets/Default.unity" };
            buildPlayerOptions.locationPathName = outfile;
            buildPlayerOptions.target = BuildTarget.Android;
            buildPlayerOptions.options = BuildOptions.None;

            BuildPipeline.BuildPlayer(buildPlayerOptions);
        }
    }
}
