using System;
using System.IO;
using UnityEngine;

namespace com.wolfired.dot_prj_stage0
{
    public sealed class PathUtils
    {
        public static string FilesystemPath2AssetPath(string filesystemPath)
        {
            // E:\path\to\u3d_prj\Assets\path\to\asset -> Assets/path/to/asset
            return filesystemPath.Replace(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar).Replace(Application.dataPath, "Assets");
        }

        public static string AssetPath2FilesystemPath(string assetPath)
        {
            // Assets/path/to/asset -> E:\path\to\u3d_prj\Assets\path\to\asset
            return Path.Combine(Path.GetDirectoryName(Application.dataPath), assetPath).Replace(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);
        }
    }
}
