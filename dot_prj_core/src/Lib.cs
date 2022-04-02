using System;
using UnityEngine;

namespace com.wolfired.dot_prj_core
{
    public class Lib { }

    public class Booter : MonoBehaviour
    {
        public void OnEnable()
        {
            Debug.Log("Booter");
            Debug.Log(Application.dataPath);
            Debug.Log(Application.streamingAssetsPath);
            Debug.Log(Application.persistentDataPath);
        }

        public void Update()
        {
            var Cube = GameObject.Find("Cube");
            Cube.transform.localScale -= new Vector3(0.01f, 0.01f, 0.01f);
        }
    }
}
