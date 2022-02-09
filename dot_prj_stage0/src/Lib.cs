using System;
using System.Collections.Generic;

using Mono.Options;

using UnityEngine;
using UnityEditor;
using UnityEditor.PackageManager.Requests;
using UnityEditor.PackageManager;

namespace com.wolfired.dot_prj_stage0
{
    public class Lib { }

    public class UnityPackageHelper
    {
        public static void ListInstalled()
        {
            GetInstalledList((pc) =>
            {
                foreach (var pi in pc)
                {
                    Debug.Log(String.Format("Installed Package List, ID: {0}, Version: {1}, DisplayName: {2}", pi.packageId, pi.version, pi.displayName));
                }
                EditorApplication.Exit(0);
            });
        }

        public static void Install()
        {
            var packageIds = new List<string>();
            var optionSet = new OptionSet{
                    {"uph_i_args_package_id=", "package id to be installed", v => packageIds.Add(v)},
                };
            optionSet.Parse(System.Environment.GetCommandLineArgs());

            GetInstalledList((pc) =>
            {
                for (int i = packageIds.Count - 1; i >= 0; --i)
                {
                    foreach (var pi in pc)
                    {
                        if (pi.packageId.StartsWith(packageIds[i]))
                        {
                            Debug.Log(String.Format("Package Already Exist, ID: {0}, DisplayName: {1}", pi.packageId, pi.displayName));
                            packageIds.RemoveAt(i);
                            break;
                        }
                    }
                }

                int countInstalled = 0;

                Action installer = null;

                installer = () =>
                {
                    if (packageIds.Count <= countInstalled)
                    {
                        EditorApplication.Exit(0);
                        return;
                    }

                    var request = Client.Add(packageIds[countInstalled]);

                    EditorApplication.CallbackFunction update = null;

                    update = () =>
                    {
                        if (!request.IsCompleted)
                        {
                            return;
                        }

                        countInstalled += 1;

                        EditorApplication.update -= update;

                        if (StatusCode.Success == request.Status)
                        {
                            Debug.Log(String.Format("Package Install Success, ID: {0}, DisplayName: {1}", request.Result.packageId, request.Result.displayName));
                        }
                        else if (StatusCode.Failure == request.Status)
                        {
                            Debug.Log(String.Format("Package Install Failure, ID: {0}", packageIds[countInstalled]));
                        }

                        installer();
                    };

                    EditorApplication.update += update;
                };

                installer();
            });
        }

        private static void GetInstalledList(Action<PackageCollection> callback)
        {
            var request = Client.List(true);

            EditorApplication.CallbackFunction update = null;

            update = () =>
            {
                if (!request.IsCompleted)
                {
                    return;
                }

                EditorApplication.update -= update;

                if (StatusCode.Success == request.Status)
                {
                    callback(request.Result);
                }
                else if (StatusCode.Failure == request.Status)
                {
                    Debug.Log(request.Error.message);
                }
            };

            EditorApplication.update += update;
        }
    }
}
