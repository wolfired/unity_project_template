using System;

using UnityEditor;
using Unity.CodeEditor;

namespace com.wolfired.dot_prj_stage1
{
    public class Lib { }

    public class CodeEditorHelper
    {
        public static void GenU3DProjectFiles()
        {
            CodeEditor.CurrentEditor.SyncAll();
            EditorApplication.Exit(0);
        }
    }
}
