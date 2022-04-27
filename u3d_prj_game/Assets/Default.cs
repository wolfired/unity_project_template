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
        var ab_common = AssetBundle.LoadFromFile(Path.Combine(Application.streamingAssetsPath, "common"));

        System.Reflection.Assembly gameAss_core;
        System.Reflection.Assembly gameAss_mod0;
        System.Reflection.Assembly gameAss_mod1;
#if UNITY_EDITOR
        gameAss_core = AppDomain.CurrentDomain.GetAssemblies().FirstOrDefault(assembly => assembly.GetName().Name == "dot_prj_core");
        gameAss_mod0 = AppDomain.CurrentDomain.GetAssemblies().FirstOrDefault(assembly => assembly.GetName().Name == "dot_prj_mod0");
        gameAss_mod1 = AppDomain.CurrentDomain.GetAssemblies().FirstOrDefault(assembly => assembly.GetName().Name == "dot_prj_mod1");
#else
        // 此代码在Android等平台下并不能工作，请酌情调整
        gameAss_core = System.Reflection.Assembly.Load(ab_common.LoadAsset<TextAsset>("dot_prj_core.dll.bytes").bytes);
        gameAss_mod0 = System.Reflection.Assembly.Load(ab_common.LoadAsset<TextAsset>("dot_prj_mod0.dll.bytes").bytes);
        gameAss_mod1 = System.Reflection.Assembly.Load(ab_common.LoadAsset<TextAsset>("dot_prj_mod1.dll.bytes").bytes);
#endif

        var types_core = gameAss_core.GetTypes();
        foreach (var type in types_core)
        {
            if ("com.wolfired.dot_prj_core.Booter" == type.FullName)
            {
                this.gameObject.AddComponent(type);
            }
        }

        var types_mod0 = gameAss_mod0.GetTypes();
        foreach (var type in types_mod0)
        {
            if ("com.wolfired.dot_prj_mod0.Mod0" == type.FullName)
            {
                this.gameObject.AddComponent(type);
            }
        }

        var go = GameObject.Instantiate(ab_common.LoadAsset<GameObject>("Startup.prefab"));
        go.name = "Startup";
    }

    // Update is called once per frame
    void Update()
    {

    }
}
