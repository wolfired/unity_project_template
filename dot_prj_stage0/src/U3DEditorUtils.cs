using UnityEngine;
using UnityEditor;

namespace com.wolfired.dot_prj_stage0
{
    public sealed class U3DEditorUtils
    {
        public static void Exit(int exit_code = 0)
        {
            if (Application.isBatchMode)
            {
                EditorApplication.Exit(exit_code);
            }
        }
    }

    public sealed class U3DEditorPrefsUtils
    {
    }

    public sealed class U3DPlayerPrefsUtils
    {

    }
}
