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
            Debug.Log("Booter!!");
            Debug.Log(Application.dataPath);
            Debug.Log(Application.streamingAssetsPath);
            Debug.Log(Application.persistentDataPath);
            foreach (var item in Directory.GetFiles(Application.streamingAssetsPath))
            {
                Debug.Log(item);
            }
        }

        public void Update()
        {
            var Cube = GameObject.Find("Cube");
            Cube.transform.localScale -= new Vector3(0.01f, 0.01f, 0.01f);

            var Sphere = GameObject.CreatePrimitive(PrimitiveType.Sphere);
            Sphere.transform.position = new Vector3(1, 1, 0);
        }
    }
}
