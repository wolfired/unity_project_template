using System;
using System.IO;

using Mono.Options;

using UnityEngine;
using UnityEditor;
using Unity.CodeEditor;
using UnityEditor.SceneManagement;
using com.wolfired.dot_prj_stage0;

namespace com.wolfired.dot_prj_stage1
{
    public class Lib { }

    public class CodeEditorHelper
    {
        public static void GenU3DProjectFiles()
        {
            CodeEditor.CurrentEditor.SyncAll();

            U3DEditorUtils.Exit(0);
        }
    }

    public class UnityEditorHelper
    {
        internal static void SetupGradle()
        {
            var prefs_key_GradleUseEmbedded = "GradleUseEmbedded";
            // var prefs_key_GradlePath = "GradlePath";
            // var prefs_key_AndroidGradleStopDaemonsOnExit = "AndroidGradleStopDaemonsOnExit";
            EditorPrefs.SetInt(prefs_key_GradleUseEmbedded, 1);
        }

        internal static void SetupJDKAndroidSDKNDK()
        {
            var prefs_key_JdkPath = "JdkPath";
            var prefs_val_JdkPath = "";

            if (EditorPrefs.HasKey(prefs_key_JdkPath))
            {
                prefs_val_JdkPath = EditorPrefs.GetString(prefs_key_JdkPath);
            }

            if (null == prefs_val_JdkPath || "" == prefs_val_JdkPath || !Directory.Exists(prefs_val_JdkPath))
            {
                var env_key_JAVA_HOME = "JAVA_HOME";
                prefs_val_JdkPath = Environment.GetEnvironmentVariable(env_key_JAVA_HOME);
                if (null == prefs_val_JdkPath || "" == prefs_val_JdkPath || !Directory.Exists(prefs_val_JdkPath))
                {
                    Debug.Log("You Need Setup Env Var: " + env_key_JAVA_HOME);
                }
                else
                {
                    EditorPrefs.SetString(prefs_key_JdkPath, prefs_val_JdkPath);
                }
            }
            Debug.Log(prefs_key_JdkPath + " = " + prefs_val_JdkPath);

            var prefs_key_AndroidNdkRoot = "AndroidNdkRoot";
            var prefs_val_AndroidNdkRoot = "";
            if (EditorPrefs.HasKey(prefs_key_AndroidNdkRoot))
            {
                prefs_val_AndroidNdkRoot = EditorPrefs.GetString(prefs_key_AndroidNdkRoot);
            }

            if (null == prefs_val_AndroidNdkRoot || "" == prefs_val_AndroidNdkRoot || !Directory.Exists(prefs_val_AndroidNdkRoot))
            {
                var env_key_ANDROID_NDK_ROOT = "ANDROID_NDK_ROOT";
                prefs_val_AndroidNdkRoot = Environment.GetEnvironmentVariable(env_key_ANDROID_NDK_ROOT);
                if (null == prefs_val_AndroidNdkRoot || "" == prefs_val_AndroidNdkRoot || !Directory.Exists(prefs_val_AndroidNdkRoot))
                {
                    var env_key_ANDROID_NDK_HOME = "ANDROID_NDK_HOME";
                    prefs_val_AndroidNdkRoot = Environment.GetEnvironmentVariable(env_key_ANDROID_NDK_HOME);
                    if (null == prefs_val_AndroidNdkRoot || "" == prefs_val_AndroidNdkRoot || !Directory.Exists(prefs_val_AndroidNdkRoot))
                    {
                        Debug.Log("You Need Setup Env Var: " + env_key_ANDROID_NDK_ROOT);
                    }
                    else
                    {
                        EditorPrefs.SetString(prefs_key_AndroidNdkRoot, prefs_val_AndroidNdkRoot);
                    }
                }
                else
                {
                    EditorPrefs.SetString(prefs_key_AndroidNdkRoot, prefs_val_AndroidNdkRoot);
                }
            }
            Debug.Log(prefs_key_AndroidNdkRoot + " = " + prefs_val_AndroidNdkRoot);

            var prefs_key_AndroidSdkRoot = "AndroidSdkRoot";
            var prefs_val_AndroidSdkRoot = "";
            if (EditorPrefs.HasKey(prefs_key_AndroidSdkRoot))
            {
                prefs_val_AndroidSdkRoot = EditorPrefs.GetString(prefs_key_AndroidSdkRoot);
            }

            if (null == prefs_val_AndroidSdkRoot || "" == prefs_val_AndroidSdkRoot || !Directory.Exists(prefs_val_AndroidSdkRoot))
            {
                var env_key_ANDROID_SDK_ROOT = "ANDROID_SDK_ROOT";
                prefs_val_AndroidSdkRoot = Environment.GetEnvironmentVariable(env_key_ANDROID_SDK_ROOT);
                if (null == prefs_val_AndroidSdkRoot || "" == prefs_val_AndroidSdkRoot || !Directory.Exists(prefs_val_AndroidSdkRoot))
                {
                    Debug.Log("You Need Setup Env Var: " + env_key_ANDROID_SDK_ROOT);
                }
                else
                {
                    EditorPrefs.SetString(prefs_key_AndroidSdkRoot, prefs_val_AndroidSdkRoot);
                }
            }
            Debug.Log(prefs_key_AndroidSdkRoot + " = " + prefs_val_AndroidSdkRoot);
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

            U3DEditorUtils.Exit(exit_code);
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

            U3DEditorUtils.Exit(0);
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

            U3DEditorUtils.Exit(0);
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

            PlayerSettings.fullScreenMode = FullScreenMode.Windowed;
            PlayerSettings.defaultScreenWidth = 1024;
            PlayerSettings.defaultScreenHeight = 768;

            PlayerSettings.companyName = "wolfired";
            PlayerSettings.productName = "winwin";

            BuildPlayerOptions buildPlayerOptions = new BuildPlayerOptions();
            buildPlayerOptions.scenes = new[] { "Assets/Default.unity" };
            buildPlayerOptions.locationPathName = outfile;
            buildPlayerOptions.target = BuildTarget.StandaloneWindows;
            buildPlayerOptions.options = BuildOptions.None;

            BuildPipeline.BuildPlayer(buildPlayerOptions);

            U3DEditorUtils.Exit(0);
        }
    }

    public class Testbed
    {
        public static void Test()
        {
            var target_group = BuildPipeline.GetBuildTargetGroup(EditorUserBuildSettings.activeBuildTarget);

            Debug.Log(PlayerSettings.GetArchitecture(target_group));
            Debug.Log(target_group);
            Debug.Log(EditorUserBuildSettings.activeBuildTarget);
            Debug.Log(BuildPipeline.IsBuildTargetSupported(BuildTargetGroup.Standalone, BuildTarget.StandaloneWindows));
            Debug.Log(BuildPipeline.IsBuildTargetSupported(BuildTargetGroup.Standalone, BuildTarget.StandaloneWindows64));

            Debug.Log(PlayerSettings.GetScriptingBackend(target_group));
            Debug.Log(PlayerSettings.GetApiCompatibilityLevel(target_group));

            Debug.Log(PlayerSettings.companyName);
            Debug.Log(PlayerSettings.productName);
            Debug.Log(PlayerSettings.productGUID);

            U3DEditorUtils.Exit(0);
        }
    }
}
