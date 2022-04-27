using System;
using System.IO;
using UnityEngine;

namespace com.wolfired.dot_prj_core
{
    public class Lib { }

    public class Booter : MonoBehaviour
    {
        public void OnEnable()
        {
            Debug.Log("Booter!");

            var Sphere = GameObject.CreatePrimitive(PrimitiveType.Cylinder);
            Sphere.transform.position = new Vector3(1, 1, 0);
        }

        public void Update()
        {
            var target = GameObject.Find("TargetBooter");
            target.transform.position += new Vector3(0, 0.01f, 0);
        }
    }

    public class Startup : MonoBehaviour
    {
        public void OnEnable()
        {
            Debug.Log("Startup!");

            var Sphere = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            Sphere.transform.position = new Vector3(-1, 1, 0);
        }

        public void Update()
        {
            var target = GameObject.Find("TargetStartup");
            target.transform.position += new Vector3(0, -0.01f, 0);
        }
    }
}
