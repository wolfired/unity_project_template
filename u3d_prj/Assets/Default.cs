using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Default : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
         var assemblies = AppDomain.CurrentDomain.GetAssemblies();
         foreach (var assembly in assemblies)
         {
             var types = assembly.GetTypes();
             foreach (var type in types)
             {
                 if("com.wolfired.dot_prj_core.Booter" == type.FullName)
                 {
                     this.gameObject.AddComponent(type);
                 }
             }
         }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
