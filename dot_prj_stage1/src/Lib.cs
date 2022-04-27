using System;
using System.IO;
using System.Collections.Generic;

using Mono.Options;

using UnityEngine;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;
using UnityEditor.SceneManagement;
using Unity.CodeEditor;

using com.wolfired.dot_prj_stage0;

namespace com.wolfired.dot_prj_stage1
{
    public class Lib { }

    public class CodeEditorHelper
    {
        public static void GenU3DProjectFiles()
        {
            UnityEditorHelper.SetupVSCode();

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

        internal static void SetupVSCode()
        {
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

            PlayerSettings.SetScriptingBackend(BuildPipeline.GetBuildTargetGroup(BuildTarget.StandaloneWindows64), ScriptingImplementation.IL2CPP);
            PlayerSettings.SetApiCompatibilityLevel(BuildPipeline.GetBuildTargetGroup(BuildTarget.StandaloneWindows64), ApiCompatibilityLevel.NET_Standard_2_0);

            PlayerSettings.companyName = "wolfired";
            PlayerSettings.productName = "winwin";

            BuildPlayerOptions buildPlayerOptions = new BuildPlayerOptions();
            buildPlayerOptions.scenes = new[] { "Assets/Default.unity" };
            buildPlayerOptions.locationPathName = outfile;
            buildPlayerOptions.target = BuildTarget.StandaloneWindows64;
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

    public class ABBuilder
    {
        [MenuItem("Tools/AB")]
        public static void Build()
        {
            var dot_prj_name_core = Environment.GetEnvironmentVariable("DOT_PRJ_NAME_CORE");
            var dot_prj_name_mods = Environment.GetEnvironmentVariable("DOT_PRJ_NAME_MODS");

            var dll_asset_paths = new List<string>();
            var dll_bytes_asset_paths = new List<string>();
            dll_asset_paths.Add("Assets/Plugins/" + dot_prj_name_core + ".dll");
            dll_bytes_asset_paths.Add("Assets/Plugins/" + dot_prj_name_core + ".dll.bytes");

            foreach (var dot_prj_name_mod in dot_prj_name_mods.Split(','))
            {
                dll_asset_paths.Add("Assets/Plugins/" + dot_prj_name_mod + ".dll");
                dll_bytes_asset_paths.Add("Assets/Plugins/" + dot_prj_name_mod + ".dll.bytes");
            }

            for (int i = 0; i < dll_asset_paths.Count; i++)
            {
                File.Copy(PathUtils.AssetPath2FilesystemPath(dll_asset_paths[i]), PathUtils.AssetPath2FilesystemPath(dll_bytes_asset_paths[i]), true);
            }

            dll_bytes_asset_paths.Add("Assets/Prefabs/Startup.prefab");

            List<AssetBundleBuild> abbs = new List<AssetBundleBuild>();
            AssetBundleBuild abb = new AssetBundleBuild
            {
                assetBundleName = "common",
                assetNames = dll_bytes_asset_paths.ToArray(),
            };
            abbs.Add(abb);
            BuildPipeline.BuildAssetBundles(Application.streamingAssetsPath, abbs.ToArray(), BuildAssetBundleOptions.None, BuildTarget.StandaloneWindows64);

            U3DEditorUtils.Exit(0);
        }
    }

    public class Adjust : IFilterBuildAssemblies, IPostprocessBuildWithReport
    {
        [Serializable]
        public class ScriptingAssemblies
        {
            public List<string> names;
            public List<int> types;
        }

        public int callbackOrder => 0;

        public string[] OnFilterAssemblies(BuildOptions buildOptions, string[] assemblies)
        {
            var dot_prj_prefix = Environment.GetEnvironmentVariable("DOT_PRJ_PREFIX");

            List<string> newNames = new List<string>(assemblies.Length);

            foreach (string assembly in assemblies)
            {
                if (!assembly.Contains(dot_prj_prefix))
                {
                    newNames.Add(assembly);
                }
            }

            return newNames.ToArray();
        }

        void IPostprocessBuildWithReport.OnPostprocessBuild(BuildReport report)
        {
            var dot_prj_name_core = Environment.GetEnvironmentVariable("DOT_PRJ_NAME_CORE");
            var dot_prj_name_mods = Environment.GetEnvironmentVariable("DOT_PRJ_NAME_MODS");

            var dll_names = new List<string>();
            dll_names.Add(dot_prj_name_core + ".dll");

            foreach (var dot_prj_name_mod in dot_prj_name_mods.Split(','))
            {
                dll_names.Add(dot_prj_name_mod + ".dll");
            }

            string[] jsonFiles = Directory.GetFiles(Path.GetDirectoryName(report.summary.outputPath), "ScriptingAssemblies.json", SearchOption.AllDirectories);

            if (jsonFiles.Length == 0)
            {
                Debug.LogError("can not find file ScriptingAssemblies.json");
                return;
            }

            foreach (string file in jsonFiles)
            {
                string content = File.ReadAllText(file);
                ScriptingAssemblies scriptingAssemblies = JsonUtility.FromJson<ScriptingAssemblies>(content);
                foreach (string name in dll_names)
                {
                    if (!scriptingAssemblies.names.Contains(name))
                    {
                        scriptingAssemblies.names.Add(name);
                        scriptingAssemblies.types.Add(16); // user dll type
                    }
                }
                content = JsonUtility.ToJson(scriptingAssemblies);

                File.WriteAllText(file, content);
            }
        }
    }
}
