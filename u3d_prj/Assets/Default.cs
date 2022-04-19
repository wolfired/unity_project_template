using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class Default : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        //  var assemblies = AppDomain.CurrentDomain.GetAssemblies();
        //  foreach (var assembly in assemblies)
        //  {
        //      var types = assembly.GetTypes();
        //      foreach (var type in types)
        //      {
        //          if("com.wolfired.dot_prj_core.Booter" == type.FullName)
        //          {
        //              this.gameObject.AddComponent(type);
        //          }
        //      }
        //  }
        System.Reflection.Assembly gameAss;
#if UNITY_EDITOR
        gameAss = AppDomain.CurrentDomain.GetAssemblies().FirstOrDefault(assembly => assembly.GetName().Name == "dot_prj_core");
#else
        // 此代码在Android等平台下并不能工作，请酌情调整
        string gameDll = Application.streamingAssetsPath + "/dot_prj_core.dll";
        gameAss = System.Reflection.Assembly.Load(File.ReadAllBytes(gameDll));
#endif
        var types = gameAss.GetTypes();
        foreach (var type in types)
        {
            if ("com.wolfired.dot_prj_core.Booter" == type.FullName)
            {
                this.gameObject.AddComponent(type);
            }
        }
    }

    // Update is called once per frame
    void Update()
    {

    }
}
