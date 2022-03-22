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
        internal static void SetupJDKAndroidSDKNDK()
        {
            var prefs_key_jdk_root = "JdkPath";
            var prefs_val_jdk_root = "";

            if (EditorPrefs.HasKey(prefs_key_jdk_root))
            {
                prefs_val_jdk_root = EditorPrefs.GetString(prefs_key_jdk_root);
            }

            if (null == prefs_val_jdk_root || "" == prefs_val_jdk_root || !Directory.Exists(prefs_val_jdk_root))
            {
                var env_key_java_home = "JAVA_HOME";
                prefs_val_jdk_root = Environment.GetEnvironmentVariable(env_key_java_home);
                if (null == prefs_val_jdk_root || "" == prefs_val_jdk_root || !Directory.Exists(prefs_val_jdk_root))
                {
                    Debug.Log("You Need Setup Env Var: " + env_key_java_home);
                }
                else
                {
                    EditorPrefs.SetString(prefs_key_jdk_root, prefs_val_jdk_root);
                }
            }
            Debug.Log(prefs_key_jdk_root + " = " + prefs_val_jdk_root);

            var prefs_key_ndk_root = "AndroidNdkRoot";
            var prefs_val_ndk_root = "";
            if (EditorPrefs.HasKey(prefs_key_ndk_root))
            {
                prefs_val_ndk_root = EditorPrefs.GetString(prefs_key_ndk_root);
            }

            if (null == prefs_val_ndk_root || "" == prefs_val_ndk_root || !Directory.Exists(prefs_val_ndk_root))
            {
                var env_key_ndk_root = "ANDROID_NDK_ROOT";
                prefs_val_ndk_root = Environment.GetEnvironmentVariable(env_key_ndk_root);
                if (null == prefs_val_ndk_root || "" == prefs_val_ndk_root || !Directory.Exists(prefs_val_ndk_root))
                {
                    var env_key_ndk_home = "ANDROID_NDK_HOME";
                    prefs_val_ndk_root = Environment.GetEnvironmentVariable(env_key_ndk_home);
                    if (null == prefs_val_ndk_root || "" == prefs_val_ndk_root || !Directory.Exists(prefs_val_ndk_root))
                    {
                        Debug.Log("You Need Setup Env Var: " + env_key_ndk_root);
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
            Debug.Log(prefs_key_ndk_root + " = " + prefs_val_ndk_root);

            var prefs_key_sdk_root = "AndroidSdkRoot";
            var prefs_val_sdk_root = "";
            if (EditorPrefs.HasKey(prefs_key_sdk_root))
            {
                prefs_val_sdk_root = EditorPrefs.GetString(prefs_key_sdk_root);
            }

            if (null == prefs_val_sdk_root || "" == prefs_val_sdk_root || !Directory.Exists(prefs_val_sdk_root))
            {
                var env_key_sdk_root = "ANDROID_SDK_ROOT";
                prefs_val_sdk_root = Environment.GetEnvironmentVariable(env_key_sdk_root);
                if (null == prefs_val_sdk_root || "" == prefs_val_sdk_root || !Directory.Exists(prefs_val_sdk_root))
                {
                    Debug.Log("You Need Setup Env Var: " + env_key_sdk_root);
                }
                else
                {
                    EditorPrefs.SetString(prefs_key_sdk_root, prefs_val_sdk_root);
                }
            }
            Debug.Log(prefs_key_sdk_root + " = " + prefs_val_sdk_root);
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
                var env_key_vscode_cmd = "VSCODE_CMD";
                prefs_val_vscode_cmd = Environment.GetEnvironmentVariable(env_key_vscode_cmd);
                if (null == prefs_val_vscode_cmd || "" == prefs_val_vscode_cmd || !File.Exists(prefs_val_vscode_cmd))
                {
                    Debug.Log("You Need Setup Env Var: " + env_key_vscode_cmd);
                    exit_code = 1;
                }
                else
                {
                    EditorPrefs.SetString(prefs_key_vscode_cmd, prefs_val_vscode_cmd);
                }
            }
            Debug.Log(prefs_key_vscode_cmd + " = " + prefs_val_vscode_cmd);


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
            Debug.Log(prefs_key_vscode_args + " = " + prefs_val_vscode_args);

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
            UnityEditorHelper.SetupJDKAndroidSDKNDK();

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

            if (Application.isBatchMode)
            {
                EditorApplication.Exit(0);
            }
        }
    }

    public class DefaultWindowsBuilder
    {
        public static void Build()
        {
            var outfile = "";
            var optionSet = new OptionSet{
                    {"builder_args_outfile=", "unity build out file", v => outfile = v},
                };
            optionSet.Parse(System.Environment.GetCommandLineArgs());

            BuildPlayerOptions buildPlayerOptions = new BuildPlayerOptions();
            buildPlayerOptions.scenes = new[] { "Assets/Default.unity" };
            buildPlayerOptions.locationPathName = outfile;
            buildPlayerOptions.target = BuildTarget.StandaloneWindows;
            buildPlayerOptions.options = BuildOptions.None;

            BuildPipeline.BuildPlayer(buildPlayerOptions);

            if (Application.isBatchMode)
            {
                EditorApplication.Exit(0);
            }
        }
    }

    public class Testbed
    {
        public static void Test()
        {
            Debug.Log(PlayerSettings.GetArchitecture(BuildPipeline.GetBuildTargetGroup(EditorUserBuildSettings.activeBuildTarget)));
            Debug.Log(BuildPipeline.GetBuildTargetGroup(EditorUserBuildSettings.activeBuildTarget));
            Debug.Log(EditorUserBuildSettings.activeBuildTarget);
            Debug.Log(BuildPipeline.IsBuildTargetSupported(BuildTargetGroup.Standalone, BuildTarget.StandaloneWindows));
            Debug.Log(BuildPipeline.IsBuildTargetSupported(BuildTargetGroup.Standalone, BuildTarget.StandaloneWindows64));

            if (Application.isBatchMode)
            {
                EditorApplication.Exit(0);
            }
        }
    }
}
