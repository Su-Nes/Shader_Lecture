using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
public class Player : MonoBehaviour
{
    public MeshRenderer meshRenderer;

    private void Update()
    {
        meshRenderer.sharedMaterial.SetVector("_PlayerPosition", transform.position);
        meshRenderer.sharedMaterial.SetFloat("_PlayerDistance", Vector3.Distance(transform.position, meshRenderer.transform.position));
    }
}
