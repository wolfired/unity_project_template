using System;
using UnityEngine;

using com.wolfired.dot_prj_core;

namespace com.wolfired.dot_prj_mod0
{
    public class Lib { }

    public class Mod0 : MonoBehaviour
    {
        public void OnEnable()
        {
            Debug.Log("Mod0! max = " + Tools.max(3, 2));
        }

        public void Update()
        {
        }
    }
}
